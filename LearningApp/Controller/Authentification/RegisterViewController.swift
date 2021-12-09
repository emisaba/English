import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var iconImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 60
        button.clipsToBounds = true
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(didTapIconImageButton), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholderText: "email")
    private let passwordTextField = CustomTextField(placeholderText: "password")
    private let nameTextField = CustomTextField(placeholderText: "name")
    
    private let registerButton = UIButton.createTextButton(title: "register", target: self, action: #selector(didTapRegisterButton))
    private let toLoginViewButton = UIButton.createTextButton(title: "to login", target: self, action: #selector(didTapToLoginViewButton))
    
    private var selectedImage: UIImage?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func registerUser() {
        guard let iconImage = selectedImage else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let userName = nameTextField.text else { return }
        let credentials = AuthCredentials(email: email, password: password, userName: userName, iconImage: iconImage)
        
        AuthService.registerUser(withCredentials: credentials) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Action
    
    @objc func didTapToLoginViewButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapRegisterButton() {
        registerUser()
    }
    
    @objc func didTapIconImageButton() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .systemYellow
        
        view.addSubview(iconImageButton)
        iconImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             paddingTop: 50)
        iconImageButton.centerX(inView: view)
        iconImageButton.setDimensions(height: 120, width: 120)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, nameTextField, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImageButton.bottomAnchor, paddingTop: 30)
        stackView.centerX(inView: view)
        stackView.setDimensions(height: 220, width: view.frame.width - 40)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.selectedImage = selectedImage
        iconImageButton.setImage(selectedImage, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
