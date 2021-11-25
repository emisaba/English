import UIKit

class topViewController: UIViewController {
    
    // MARK: - Properties
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var cameraButton = createButton(image: #imageLiteral(resourceName: "camera"), selector: #selector(didTapCameraButton))
    private lazy var micButton = createButton(image: #imageLiteral(resourceName: "camera"), selector: #selector(didTapMicButton))
    
    var audioData: NSMutableData!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func didTapCameraButton() {
    }
    
    @objc func didTapMicButton(_ sender: UIButton) {
        
//        let inputController = EnglishInputViewController()
//        let nc = UINavigationController(rootViewController: inputController)
//        present(nc, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(cardView)
        cardView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 25,
                        paddingRight: 25,
                        height: view.frame.height - 200)
        
        let buttonStackView = UIStackView(arrangedSubviews: [UIView(),
                                                             cameraButton,
                                                             UIView(),
                                                             micButton,
                                                             UIView()])
        buttonStackView.distribution = .fillEqually
        
        view.addSubview(buttonStackView)
        buttonStackView.anchor(left: view.leftAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.rightAnchor,
                               paddingLeft: 25,
                               paddingBottom: 25,
                               paddingRight: 25)
    }
    
    func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
