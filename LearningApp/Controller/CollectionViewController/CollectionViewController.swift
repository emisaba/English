import UIKit
import SDWebImage
import ViewAnimator
import Hero

enum HeaderButtons {
    case back
    case add
}

class CollectionViewController: UIViewController {
    
    // MARK: - properties
    
    public let identifier = "identifier"
    
    private lazy var backToHomeButton = UIButton.createImageButton(image: #imageLiteral(resourceName: "angle-left"), target: self, action: #selector(didTapBackToHome))
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add-fill"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapAddCardButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        return button
    }()
    
    private lazy var addCollectionAlert: CustomAlertView = {
        let alert = CustomAlertView()
        alert.delegate = self
        return alert
    }()
    
    private let backgroundViewForAlert: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private var selectedImage: UIImage?
    private var categories: [UserCategory] = [] {
        didSet { collectionView.reloadData() }
    }
    
    public lazy var headerView: CategoryView = {
        let view = CategoryView()
        view.delegate = self
        view.isStudyVC = false
        view.imageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        cv.backgroundColor = UIColor.darkColor()
        cv.alpha = 0
        return cv
    }()
    
    private var cellInfos: [[String: Any]] = [[:]]
    private var categoryTitle: String?
    
    public var viewModel: CategoryViewModel
    
    public var collectionType: CollectionType = .user
    
    public var userCollections: [UserCollection] = [] {
        didSet { collectionView.reloadData() }
    }
    
    public var downloadCollections: [UserCollection] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private let selectedCategory: CategoryView
    
    // MARK: - Lifecycle
    
    init(category: UserCategory, selectedCategory: CategoryView) {
        self.viewModel = CategoryViewModel(category: category)
        self.selectedCategory = selectedCategory
        
        super.init(nibName: nil, bundle: nil)
        self.headerView.viewModel = CategoryViewModel(category: category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserCollections()
        fetchDownloadCollections()
        
        configureHeader()
        configureCollection()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundViewForAlert.alpha = 0
            
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.addCollectionAlert.frame.origin.y = -350
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.tabBarView.isHidden = true
    }
    
    // MARK: - API
    
    func fetchUserCollections() {
        let categoryID = viewModel.category.categoryID
        
        CardService.fetchUserCollections(categoryID: categoryID) { collections in
            self.userCollections = collections
        }
    }
    
    func fetchDownloadCollections() {
        let categoryID = viewModel.category.categoryID
        
        CardService.fetchDownloadCollection(categoryID: categoryID) { collections in
            self.downloadCollections = collections
        }
    }
    
    func createNewCollection(collectionInfo: CollectionInfo, alertView: CustomAlertView) {
        UIView.animate(withDuration: 0.3) {
            self.addCollectionAlert.center.y += 150
        }
        showLoader(true)
        
        CardService.createUserCollection(collectionInfo: collectionInfo) { collectionID in
            
            let itemInfo = ItemInfo(categoryID: collectionInfo.categoryID,
                                    collectionID: collectionID,
                                    image: collectionInfo.image)
            
            self.presentCaptureView(itemInfo: itemInfo, alertView: alertView)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapAddCardButton() {
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundViewForAlert.alpha = 0.5
            
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.addCollectionAlert.center.y = self.view.frame.height / 2
            }
        }
    }
    
    @objc func didTapBackToHome() {
        dismiss(animated: true) { self.selectedCategory.hero.id = "" }
    }
    
    // MARK: - Helpers
    
    func configureHeader() {
        view.addSubview(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2.5)
        
        view.addSubview(backToHomeButton)
        backToHomeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                left: view.leftAnchor,
                                paddingTop: -10,
                                paddingLeft: 10)
        backToHomeButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(addCardButton)
        addCardButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                             right: view.rightAnchor,
                             paddingTop: -10,
                             paddingRight: 10)
        addCardButton.setDimensions(height: 60, width: 60)
    }
    
    func configureCollection() {
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: view.frame.height / 2.5)
        
        view.addSubview(backgroundViewForAlert)
        backgroundViewForAlert.fillSuperview()
        
        view.addSubview(addCollectionAlert)
        addCollectionAlert.frame = CGRect(x: 0, y: -350,
                                    width: view.frame.width - 40,
                                    height: 350)
        addCollectionAlert.center.x = view.frame.width / 2
        
        UIView.animate(withDuration: 0.25) {
            self.collectionView.alpha = 1
        }
    }
    
    func presentCaptureView(itemInfo: ItemInfo, alertView: CustomAlertView) {
        
        let vc = CardViewController(cardType: .capture,
                                    itemInfo: itemInfo,
                                    sentences: nil,
                                    words: nil,
                                    testCardType: .all,
                                    japanese: false,
                                    itemViewController: nil)
        
        vc.collectionAddImageButton = alertView.addImageButton
        alertView.addImageButton.hero.id = "moveToCaptureView"
        
        vc.captureBackgroundImage.hero.id = "moveToCaptureView"
        vc.modalPresentationStyle = .fullScreen
        vc.collectionViewController = self
        vc.isHeroEnabled = true
        
        self.present(vc, animated: true) { [weak self] in
            
            guard let `self` = self else { return }
            `self`.addCollectionAlert.frame.origin.y = -350
            `self`.backgroundViewForAlert.alpha = 0

            alertView.nameTextField.text = ""
            
            self.view.endEditing(true)
            self.showLoader(false)
        }
    }
}

// MARK: - CustomAlertViewDelegate

extension CollectionViewController: CustomAlertViewDelegate {
    func imagePicker(view: CustomAlertView) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true) {
            view.showImagePickerUI()
        }
    }
    
    func beginEditing() {
        UIView.animate(withDuration: 0.3) {
            self.addCollectionAlert.center.y -= 150
        }
    }
    
    func showRegisterView(view: CustomAlertView) {
        
        guard let collectionTitle = view.nameTextField.text else { return }
        guard let image = selectedImage else { return }
        
        let collectionInfo = CollectionInfo(categoryID: viewModel.category.categoryID,
                                            collectionTitle: collectionTitle,
                                            image: image)
        
        self.createNewCollection(collectionInfo: collectionInfo, alertView: view)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        addCollectionAlert.addImageButton.setImage(image, for: .normal)

        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CategoryViewDelegate

extension CollectionViewController: CategoryViewDelegate {
    
    func didSelectCategory(categoryType: CollectionType) {
        switch categoryType {
        case .user:
            collectionType = .user
            
        case .download:
            collectionType = .download
        }
        
        collectionView.reloadData()
    }
}
