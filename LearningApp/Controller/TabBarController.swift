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
    
    func buttonTapped(selectedTab: selectedTab, tab: CustomTabBar) {
        
        switch selectedTab {
        case .study:
            selectedIndex = 0
            tab.studyButton.backgroundColor = UIColor.lightColor()
            tab.searchButton.backgroundColor = UIColor.darkColor()
            tab.notificationButton.backgroundColor = UIColor.darkColor()
            tab.myPageButton.backgroundColor = UIColor.darkColor()
            
        case .search:
            selectedIndex = 1
            tab.studyButton.backgroundColor = UIColor.darkColor()
            tab.searchButton.backgroundColor = UIColor.lightColor()
            tab.notificationButton.backgroundColor = UIColor.darkColor()
            tab.myPageButton.backgroundColor = UIColor.darkColor()
            
        case .notification:
            selectedIndex = 2
            tab.studyButton.backgroundColor = UIColor.darkColor()
            tab.searchButton.backgroundColor = UIColor.darkColor()
            tab.notificationButton.backgroundColor = UIColor.lightColor()
            tab.myPageButton.backgroundColor = UIColor.darkColor()
            
        case .myPage:
            selectedIndex = 3
            tab.studyButton.backgroundColor = UIColor.darkColor()
            tab.searchButton.backgroundColor = UIColor.darkColor()
            tab.notificationButton.backgroundColor = UIColor.darkColor()
            tab.myPageButton.backgroundColor = UIColor.lightColor()
        }
    }
}

