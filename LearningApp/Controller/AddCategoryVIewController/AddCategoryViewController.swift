import UIKit
import Hero

class AddCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "angle-left"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private let imageSelectButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 60
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapImageSelectButton), for: .touchUpInside)
        return button
    }()
    
    private let plusImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "add-fill")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var selectedImage: UIImage?
    
    private lazy var categoryTextField: CustomTextField = {
        let tf = CustomTextField(placeholderText: " カテゴリを入力")
        tf.delegate = self
        return tf
    }()
    
    private lazy var collectionTextField: CustomTextField = {
        let tf = CustomTextField(placeholderText: " コレクションを入力")
        tf.delegate = self
        return tf
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 18), .foregroundColor: UIColor.white, .kern: 2]
        let attributeTitle = NSAttributedString(string: "登録", attributes: attrubutes)
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0.4
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func createNewCategory(categoryInfo: CategoryInfo) {
        
        CardService.createUserCategory(categoryInfo: categoryInfo) { id in
            self.showLoader(false)
            
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
    
    @objc func didTapClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapImageSelectButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true) {
            self.plusImageView.isHidden = true
            self.imageSelectButton.layer.borderWidth = 0
        }
    }
    
    @objc func didTapSaveButton() {
        showLoader(true)
        
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
        
        view.backgroundColor = UIColor.darkColor()
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           left: view.leftAnchor,
                           paddingLeft: 20)
        closeButton.setDimensions(height: 30, width: 30)
        
        view.addSubview(imageSelectButton)
        imageSelectButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        imageSelectButton.setDimensions(height: 120, width: 120)
        imageSelectButton.centerX(inView: view)
        
        imageSelectButton.addSubview(plusImageView)
        plusImageView.setDimensions(height: 20, width: 20)
        plusImageView.centerY(inView: imageSelectButton)
        plusImageView.centerX(inView: imageSelectButton)
        
        categoryTextField.backgroundColor = .clear
        collectionTextField.backgroundColor = .clear
        
        let categoryTextFieldLine = createUnderLine()
        categoryTextField.addSubview(categoryTextFieldLine)
        categoryTextFieldLine.anchor(left: categoryTextField.leftAnchor,
                                     bottom: categoryTextField.bottomAnchor,
                                     right: categoryTextField.rightAnchor,
                                     height: 1)
        
        let collectionTextFieldLine = createUnderLine()
        collectionTextField.addSubview(collectionTextFieldLine)
        collectionTextFieldLine.anchor(left: collectionTextField.leftAnchor,
                                     bottom: collectionTextField.bottomAnchor,
                                     right: collectionTextField.rightAnchor,
                                     height: 1)
        
        let stackView = UIStackView(arrangedSubviews: [categoryTextField, collectionTextField])
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
                         height: 140)
        
        view.addSubview(blurEffectView)
        blurEffectView.anchor(top: stackView.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 60,
                              paddingLeft: 30,
                              paddingRight: 30,
                              height: 60)
        
        view.addSubview(saveButton)
        saveButton.anchor(top: stackView.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 60,
                              paddingLeft: 30,
                              paddingRight: 30,
                              height: 60)

    }
    
    func createUnderLine() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
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

// MARK: - UITextFieldDelegate

extension AddCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == collectionTextField {
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.lexendDecaRegular(size: 18)]
            textField.attributedText = NSAttributedString(string: textField.text ?? "", attributes: attributes)
        }
    }
}
