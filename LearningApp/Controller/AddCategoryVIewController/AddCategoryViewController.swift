import UIKit
import Hero

class AddCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        button.addTarget(self, action: #selector(didTspClose), for: .touchUpInside)
        return button
    }()
    
    private let imageSelectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 75
        button.addTarget(self, action: #selector(didTapImageSelectButton), for: .touchUpInside)
        return button
    }()
    
    private var selectedImage: UIImage?
    
    private let categoryTextField = CustomTextField(placeholderText: "カテゴリを入力")
    private let collectionTextField = CustomTextField(placeholderText: "セクションを入力")
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .lexendDecaBold(size: 18)
        button.layer.cornerRadius = 75
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func createNewCategory(categoryInfo: CategoryInfo) {
        
        CardService.createUserCategory(categoryInfo: categoryInfo) { id in
            
            guard let collectionImage = self.selectedImage else { return }
            let itemInfo = ItemInfo(categoryID: id.category,
                                    collectionID: id.collection,
                                    image: collectionImage)
            
            let vc = CardViewController(cardType: .capture,
                                        itemInfo: itemInfo,
                                        sentences: nil,
                                        words: nil,
                                        testCardType: .all,
                                        japanese: false,
                                        itemViewController: nil)
            
            self.imageSelectButton.hero.id = "moveToCaptureView"
            vc.captureBackgroundImage.hero.id = "moveToCaptureView"
            vc.modalPresentationStyle = .fullScreen
            vc.addCategoryViewController = self
            vc.isHeroEnabled = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTspClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapImageSelectButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func didTapSaveButton() {
        view.endEditing(true)
        
        guard let categoryTitle = categoryTextField.text else { return }
        guard let collectionTitle = collectionTextField.text else { return }
        guard let image = selectedImage else { return }
        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
                                        collectionTitle: collectionTitle,
                                        image: image, sentence: nil, word: nil)
        createNewCategory(categoryInfo: categoryInfo)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingTop: 10, paddingRight: 20)
        closeButton.setDimensions(height: 50, width: 50)
        
        view.addSubview(imageSelectButton)
        imageSelectButton.anchor(top: closeButton.bottomAnchor,
                                 paddingTop: 10)
        imageSelectButton.setDimensions(height: 150, width: 150)
        imageSelectButton.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [categoryTextField, collectionTextField, saveButton])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: imageSelectButton.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 30,
                         paddingRight: 30,
                         height: 170)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AddCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        imageSelectButton.setImage(image, for: .normal)
        selectedImage = image
        
        dismiss(animated: true)
    }
}
