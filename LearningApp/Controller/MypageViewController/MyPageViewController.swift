import UIKit
import Firebase

class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoutButton = UIButton.createTextButton(title: "", target: self, action: #selector(didTapLogoutButton))
    
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
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            
            present(nav, animated: true) {
                guard let tc = self.tabBarController as? TabBarController else { return }
                tc.tabBarView.configureUI()
                tc.selectedIndex = 0
            }
            
        } catch {
            print("failed to sign out")
        }
    }
    
    // MARK: - Action
    
    @objc func didTapLogoutButton() {
        logout()
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(logoutButton)
        logoutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            right: view.rightAnchor,
                            paddingTop: 10,
                            paddingRight: 20)
        logoutButton.setDimensions(height: 60, width: 60)
        logoutButton.backgroundColor = .systemBlue
    }
}

