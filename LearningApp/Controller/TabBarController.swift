import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    // MARK: - Property
    
    public lazy var tabBarView: CustomTabBar = {
        let tabBar = CustomTabBar()
        tabBar.delegate = self
        return tabBar
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        configureUI()
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        let currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            DispatchQueue.main.async {
                let  vc = LoginViewController()
                let nc = UINavigationController(rootViewController: vc)
                nc.modalPresentationStyle = .fullScreen
                self.present(nc, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - Helper
    
    func configureUI() {
        let studyVC = UINavigationController(rootViewController: StudyViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let notificationVC = UINavigationController(rootViewController: NotificationViewController())
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        
        viewControllers = [studyVC, searchVC, notificationVC, myPageVC]
        tabBar.isHidden = true
        
        view.addSubview(tabBarView)
        tabBarView.anchor(left: view.leftAnchor,
                          bottom: view.bottomAnchor,
                          right: view.rightAnchor,
                          height: 100)
    }
}

// MARK: - CustomTabBarDelegate

extension TabBarController: CustomTabBarDelegate {
    
    func buttonTapped(selectedTab: selectedTab) {
        
        switch selectedTab {
        case .study:
            selectedIndex = 0
            
        case .search:
            selectedIndex = 1
            
        case .notification:
            selectedIndex = 2
            
        case .myPage:
            selectedIndex = 3
        }
    }
}

