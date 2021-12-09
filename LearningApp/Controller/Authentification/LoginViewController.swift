import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let emailTextField = CustomTextField(placeholderText: "email")
    private let passwordTextField = CustomTextField(placeholderText: "password")
    private let loginButton = UIButton.createTextButton(title: "login", target: self, action: #selector(didTapLoginButton))
    private let toRegisterViewButton = UIButton.createTextButton(title: "register", target: self, action: #selector(didTapToRegisterButton))
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    
    func fetchLogUserIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(with: email, password: password) { _, error in
            if let error = error {
                print("failed to log user in: \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Action
    
    @objc func didTapLoginButton() {
        fetchLogUserIn()
    }
    
    @objc func didTapToRegisterButton() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemYellow
        
        view.addSubview(stackView)
        stackView.centerY(inView: view)
        stackView.centerX(inView: view)
        stackView.setDimensions(height: 220, width: view.frame.width - 40)
        
        view.addSubview(toRegisterViewButton)
        toRegisterViewButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: 10, paddingRight: 10)
        toRegisterViewButton.setDimensions(height: 60, width: 60)
        toRegisterViewButton.backgroundColor = .systemPink
    }
}
