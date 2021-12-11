import UIKit
import SDWebImage
import ViewAnimator
import Hero

class CollectionViewController: UIViewController {
    
    // MARK: - properties
    
    private let identifier = "identifier"
    
    private lazy var backToHomeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapBackToHome), for: .touchUpInside)
        return button
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapAddCardButton), for: .touchUpInside)
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
    
    private var cellImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    public lazy var headerView: CategoryView = {
        let view = CategoryView()
        view.delegate = self
        view.isStudyVC = false
        view.imageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        view.titleLabel.text = viewModel.categoryTitle
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        cv.alpha = 0
        return cv
    }()
    
    private var cellInfos: [[String: Any]] = [[:]]
    private var categoryTitle: String?
    
    public var viewModel: CategoryViewModel
    
    private var collectionType: CollectionType = .user
    
    private var userCollections: [UserCollection] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private var downloadCollections: [UserCollection] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private let selectedCategory: CategoryView
    
    // MARK: - Lifecycle
    
    init(category: UserCategory, selectedCategory: CategoryView) {
        self.viewModel = CategoryViewModel(category: category)
        self.selectedCategory = selectedCategory
        
        super.init(nibName: nil, bundle: nil)
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
        headerView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 240)
        
        view.addSubview(backToHomeButton)
        backToHomeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                left: view.leftAnchor,
                                paddingTop: 10,
                                paddingLeft: 10)
        backToHomeButton.setDimensions(height: 50, width: 50)
        
        view.addSubview(addCardButton)
        addCardButton.anchor(right: view.rightAnchor,
                             paddingRight: 10)
        addCardButton.setDimensions(height: 50, width: 50)
        addCardButton.centerY(inView: headerView)
    }
    
    func configureCollection() {
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 240)
        collectionView.backgroundColor = .white
        
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
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionType == .user ? userCollections.count : downloadCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionViewCell
        
        let collection = collectionType == .user ? userCollections[indexPath.row] : downloadCollections[indexPath.row]
        cell.viewModel = CollectionViewmodel(collection: collection)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        guard let image = cell.imageView.image else { return }
        let selectedCollection = userCollections[indexPath.row]
        
        let itemInfo = ItemInfo(categoryID: selectedCollection.categoryID,
                                collectionID: selectedCollection.collectionID,
                                image: image)
        
        cell.hero.id = "moveToItemVC"
        
        let vc = ItemViewController(itemInfo: itemInfo, selectedCollection: cell)
        vc.modalPresentationStyle = .fullScreen
        vc.imageView.hero.id = "moveToItemVC"
        vc.visualEffectView.hero.id = "moveToItemVC"
        vc.isHeroEnabled = true
        
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gapSum: CGFloat = 20
        let width = (view.frame.width - gapSum) / 3
        let height = view.frame.height / 4
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


// MARK: - CustomAlertViewDelegate

extension CollectionViewController: CustomAlertViewDelegate {
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
    
    func imagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
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
