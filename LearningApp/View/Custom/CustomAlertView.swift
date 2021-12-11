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
        button.layer.cornerRadius = 60
        button.clipsToBounds = true
        button.backgroundColor = .systemTeal
        button.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var nameTextField: CustomTextField = {
        let tf = CustomTextField(placeholderText: "コレクションを入力")
        tf.delegate = self
        return tf
    }()
    
    private lazy var doneButton: UIButton = {
       let button = UIButton()
        button.setTitle("save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .lexendDecaBold(size: 18)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.backgroundColor = .lightGray.withAlphaComponent(0.3)
        button.layer.cornerRadius = 5
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
        
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(addImageButton)
        addImageButton.anchor(top: topAnchor,
                        paddingTop: 20)
        addImageButton.setDimensions(height: 120, width: 120)
        addImageButton.centerX(inView: self)
        
        addSubview(nameTextField)
        nameTextField.anchor(top: addImageButton.bottomAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        paddingTop: 20,
                        paddingLeft: 20,
                        paddingRight: 20,
                        height: 50)
        
        addSubview(doneButton)
        doneButton.anchor(left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 20,
                          paddingBottom: 20,
                          paddingRight: 20,
                          height: 50)
    }
}

// MARK: - UITextFieldDelegate

extension CustomAlertView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isSaved { return }
        delegate?.beginEditing()
    }
}
