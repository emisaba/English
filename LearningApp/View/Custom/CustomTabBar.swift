import UIKit

enum selectedTab {
    case study
    case search
    case notification
    case myPage
}

protocol CustomTabBarDelegate {
    func buttonTapped(selectedTab: selectedTab, tab: CustomTabBar)
}

class CustomTabBar: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomTabBarDelegate?
    
    public lazy var studyButton = createTabButton(image: #imageLiteral(resourceName: "pen"), tag: 0, title: "study")
    public lazy var searchButton = createTabButton(image: #imageLiteral(resourceName: "search"), tag: 1, title: "")
    public lazy var notificationButton = createTabButton(image: #imageLiteral(resourceName: "notification-line"), tag: 2, title: "")
    public lazy var myPageButton = createTabButton(image: #imageLiteral(resourceName: "user"), tag: 3, title: "")
    
    private let normalButtonWidth: CGFloat = 60
    private let space: CGFloat = 10
    private lazy var selectedButtonWidth: CGFloat = (frame.width - space * 5) / 4 * 2 - space
    
    private lazy var searchButtonOriginalX: CGFloat = space * 2 + selectedButtonWidth
    private lazy var notificationButtonOriginalX: CGFloat = space * 3 + selectedButtonWidth + normalButtonWidth
    private lazy var myPageButtonOriginalX: CGFloat = frame.width - (space + normalButtonWidth)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    // MARK: - Action
    
    @objc func didTapButton(sender: UIButton) {
        
        UIView.animate(withDuration: 0.25) {
            
            switch sender.tag {
            case 0:
                self.selectStudyButtonAnimation()
                self.delegate?.buttonTapped(selectedTab: .study, tab: self)
                
            case 1:
                self.selectSearchButtonAnimation()
                self.delegate?.buttonTapped(selectedTab: .search, tab: self)
                
            case 2:
                self.selectNotificationButtonAnimation()
                self.delegate?.buttonTapped(selectedTab: .notification, tab: self)
                
            case 3:
                self.selectMyPageButtonAnimation()
                self.delegate?.buttonTapped(selectedTab: .myPage, tab: self)
                
            default:
                break
            }
        }
    }
    
    // MARK: - Helper
    
    func createTabButton(image: UIImage, tag: Int, title: String) -> UIButton {
        
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.tag = tag
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 14), .kern: 5, .foregroundColor: UIColor.white]
        let attributeString = NSAttributedString(string: title, attributes: attrubutes)
        
        button.setAttributedTitle(attributeString, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        
        button.addSubview(imageView)
        
        return button
    }
    
    func createAttributeString(title: String) -> NSAttributedString {
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 14), .kern: 5, .foregroundColor: UIColor.white]
        let attributeString = NSAttributedString(string: title, attributes: attrubutes)
        return attributeString
    }
    
    func configureUI() {
        let baseView = UIView()
        baseView.frame = bounds
        baseView.backgroundColor = UIColor.darkColor()
        baseView.layer.cornerRadius = frame.height / 2
        addSubview(baseView)
        
        baseView.addSubview(studyButton)
        studyButton.frame = CGRect(x: space, y: space,
                                   width: selectedButtonWidth,
                                   height: normalButtonWidth)
        studyButton.backgroundColor = UIColor.lightColor()
        
        baseView.addSubview(searchButton)
        searchButton.frame = CGRect(x: searchButtonOriginalX,
                                    y: space,
                                    width: normalButtonWidth,
                                    height: normalButtonWidth)
        searchButton.backgroundColor = UIColor.darkColor()

        baseView.addSubview(notificationButton)
        notificationButton.frame =  CGRect(x: notificationButtonOriginalX,
                                           y: space,
                                           width: normalButtonWidth,
                                           height: normalButtonWidth)
        notificationButton.backgroundColor = UIColor.darkColor()
        
        baseView.addSubview(myPageButton)
        myPageButton.frame =  CGRect(x: myPageButtonOriginalX,
                                     y: space,
                                     width: normalButtonWidth,
                                     height: normalButtonWidth)
        myPageButton.backgroundColor = UIColor.darkColor()
    }
    
    func selectStudyButtonAnimation() {
        self.studyButton.frame.size.width = self.selectedButtonWidth
        self.searchButton.frame.size.width = self.normalButtonWidth
        self.notificationButton.frame.size.width = self.normalButtonWidth
        self.myPageButton.frame.size.width = self.normalButtonWidth
        
        self.notificationButton.frame.origin.x = self.notificationButtonOriginalX
        self.searchButton.frame.origin.x = self.searchButtonOriginalX
        self.myPageButton.frame.origin.x = self.myPageButtonOriginalX
        
        studyButton.setAttributedTitle(createAttributeString(title: "study"), for: .normal)
        searchButton.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
    }
    
    func selectSearchButtonAnimation() {
        self.studyButton.frame.size.width = self.normalButtonWidth
        self.searchButton.frame.size.width = self.selectedButtonWidth
        self.notificationButton.frame.size.width = self.normalButtonWidth
        self.myPageButton.frame.size.width = self.normalButtonWidth
        
        self.searchButton.frame.origin.x = self.searchButtonOriginalX
        self.searchButton.frame.origin.x -= (self.selectedButtonWidth - self.normalButtonWidth)
        
        self.notificationButton.frame.origin.x = self.notificationButtonOriginalX
        self.myPageButton.frame.origin.x = self.myPageButtonOriginalX
        
        studyButton.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
        searchButton.setAttributedTitle(createAttributeString(title: "search"), for: .normal)
    }
    
    func selectNotificationButtonAnimation() {
        self.studyButton.frame.size.width = self.normalButtonWidth
        self.searchButton.frame.size.width = self.normalButtonWidth
        self.notificationButton.frame.size.width = self.selectedButtonWidth
        self.myPageButton.frame.size.width = self.normalButtonWidth
        
        self.notificationButton.frame.origin.x = self.notificationButtonOriginalX
        self.notificationButton.frame.origin.x -= (self.selectedButtonWidth - self.normalButtonWidth)
        
        self.searchButton.frame.origin.x = self.searchButtonOriginalX
        self.searchButton.frame.origin.x -= (self.selectedButtonWidth - self.normalButtonWidth)
        
        self.myPageButton.frame.origin.x = self.myPageButtonOriginalX
    }
    
    func selectMyPageButtonAnimation() {
        self.studyButton.frame.size.width = self.normalButtonWidth
        self.searchButton.frame.size.width = self.normalButtonWidth
        self.notificationButton.frame.size.width = self.normalButtonWidth
        self.myPageButton.frame.size.width = self.selectedButtonWidth
        
        self.notificationButton.frame.origin.x = self.notificationButtonOriginalX
        self.notificationButton.frame.origin.x -= (self.selectedButtonWidth - self.normalButtonWidth)
        
        self.searchButton.frame.origin.x = self.searchButtonOriginalX
        self.searchButton.frame.origin.x -= (self.selectedButtonWidth - self.normalButtonWidth)
        
        self.myPageButton.frame.origin.x = self.myPageButtonOriginalX
        self.myPageButton.frame.origin.x -= (self.selectedButtonWidth - self.normalButtonWidth)
    }
}
