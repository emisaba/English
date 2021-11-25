import UIKit
import SDWebImage
import ViewAnimator

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
    
    private lazy var addCartAlert: CustomAlertView = {
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
    private var categories: [Category] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private var cellImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let headerImageFrame: CGRect
    private let headerView = CategoryView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(collectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        cv.alpha = 0
        return cv
    }()
    
    private var cellInfos: [[String: Any]] = [[:]]
    private var categoryTitle: String?
    
    public var viewModel: CategoryViewmodel
    private var collections: [Collection]? {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(category: Category, frame: CGRect) {
        self.viewModel = CategoryViewmodel(category: category)
        self.headerImageFrame = frame
        self.headerView.frame = frame
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCollections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
        configureHeaderVIew()
    }
    
    // MARK: - API
    
    func fetchCollections() {
        guard let categoryTitle = viewModel.categoryTitle else { return }
        
        CreateCardService.fetchCollections(categoryTitle: categoryTitle) { collections in
            self.collections = collections
        }
    }
    
    func createNewCollection(info: CategoryInfo) {
        
        CreateCardService.createCollection(categoryInfo: info) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let vc = CardViewController(cardType: .capture, categoryInfo: info,
                                        sentences: nil, words: nil,
                                        testCardType: .all, japanese: false)
            
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Helpers
    
    func configureHeaderVIew() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.view.addSubview(self.headerView)
            self.headerView.frame = CGRect(x: 0, y: 0,
                                           width: self.view.frame.width,
                                           height: 240)
            self.headerView.imageView.sd_setImage(with: self.viewModel.imageUrl)
            self.headerView.titleLabel.text = self.viewModel.categoryTitle
            
        } completion: { done in
            if done {
                
                self.view.addSubview(self.backToHomeButton)
                self.backToHomeButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                                             left: self.view.leftAnchor,
                                             paddingTop: 10, paddingLeft: 10)
                self.backToHomeButton.setDimensions(height: 50, width: 50)
                
                self.view.addSubview(self.addCardButton)
                self.addCardButton.anchor(right: self.view.rightAnchor,
                                          paddingRight: 30)
                self.addCardButton.setDimensions(height: 50, width: 50)
                self.addCardButton.centerY(inView: self.headerView)
                
                self.configureCollection()
            }
        }
    }
    
    func configureCollection() {
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 240)
        collectionView.backgroundColor = .white
        
        view.addSubview(backgroundViewForAlert)
        backgroundViewForAlert.fillSuperview()
        
        view.addSubview(addCartAlert)
        addCartAlert.center.x = view.frame.width / 2
        addCartAlert.frame = CGRect(x: 0, y: -350,
                                    width: view.frame.width - 40,
                                    height: 350)
        
        UIView.animate(withDuration: 0.25) {
            self.collectionView.alpha = 1
        }
    }
    
    func hideViews(views: [UIView]) {
        views.forEach { $0.isHidden = true }
    }
    
    // MARK: - Actions
    
    @objc func didTapAddCardButton() {
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundViewForAlert.alpha = 0.5
            
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.addCartAlert.frame.origin.y = 100
                
            }
        }
    }
    
    @objc func didTapBackToHome() {
        
        let hideViews = [addCardButton, backToHomeButton, collectionView]
        
        UIView.animate(withDuration: 0.25) {
            self.hideViews(views: hideViews)
            
        } completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.headerView.frame = self.headerImageFrame
                
            } completion: { _ in
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! collectionViewCell
        
        if let collections = collections {
            cell.viewModel = CollectionViewmodel(collection: collections[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? collectionViewCell else { return }
        let headerViewHeight: CGFloat = 200
        var frame = cell.frame
        frame.origin.y += headerViewHeight
        
        guard let categoryTitle = viewModel.categoryTitle else { return }
        guard let collectionTitle = collections?[indexPath.row].collectionTitle else { return }
        let image = cell.imageView.image
        
        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
                                        collectionTitle: collectionTitle,
                                        image: image,
                                        sentence: nil,
                                        word: nil)
        
        let vc = ItemViewController(imageViewFrame: frame, categoryInfo: categoryInfo)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: false)
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
    
    func showRegisterView(view: CustomAlertView) {
        guard let categoryTitle = viewModel.categoryTitle else { return }
        guard let collectionTitle = view.inputNameField.text else { return }
        guard let image = selectedImage else { return }
        
        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
                                        collectionTitle: collectionTitle,
                                        image: image, sentence: nil, word: nil)
        
        createNewCollection(info: categoryInfo)
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
        addCartAlert.addImageButton.setImage(image, for: .normal)

        dismiss(animated: true, completion: nil)
    }
}
