import UIKit

protocol CustomAlertViewDelegate {
    func showRegisterView(view: CustomAlertView)
    func imagePicker()
    func beginEditing()
}

class CustomAlertView: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomAlertViewDelegate?
    
    public lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.contentEdgeInsets = UIEdgeInsets(top: 45, left: 45, bottom: 45, right: 45)
        button.clipsToBounds = true
        button.layer.cornerRadius = 60
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var nameTextField: CustomTextField = {
        let tf = CustomTextField(placeholderText: "コレクションを入力")
        tf.delegate = self
        return tf
    }()
    
    private let nameTextFieldBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.backgroundColor = .redColor()
        button.layer.cornerRadius = 30
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 16), .kern: 6]
        let attributedString = NSAttributedString(string: "save", attributes: attrubutes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    private var isSaved = false
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapSaveButton() {
        isSaved = true
        delegate?.showRegisterView(view: self)
    }
    
    @objc func didTapAddImageButton() {
        delegate?.imagePicker()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = .lightColor()
        layer.cornerRadius = 10
        
        addSubview(addImageButton)
        addImageButton.anchor(top: topAnchor,
                              paddingTop: 30)
        addImageButton.setDimensions(height: 120, width: 120)
        addImageButton.centerX(inView: self)
        
        addSubview(nameTextField)
        nameTextField.anchor(top: addImageButton.bottomAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 30,
                             paddingLeft: 20,
                             paddingRight: 20,
                             height: 60)
        
        addSubview(nameTextFieldBottomLine)
        nameTextFieldBottomLine.anchor(left: nameTextField.leftAnchor,
                                       bottom: nameTextField.bottomAnchor,
                                       right: nameTextField.rightAnchor,
                                       height: 1)
        
        addSubview(saveButton)
        saveButton.anchor(left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 20,
                          paddingBottom: 20,
                          paddingRight: 20,
                          height: 60)
    }
}

// MARK: - UITextFieldDelegate

extension CustomAlertView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isSaved { return }
        delegate?.beginEditing()
    }
}
