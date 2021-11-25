import UIKit

class CustomSegmentControl: UIView {
    
    // MARK: - Properties
    
    private lazy var leftButton = createButton(title: "left", x: 0)
    private lazy var rightButton = createButton(title: "right", x: frame.width/2)
    
    private lazy var tapView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = (frame.height - 10) / 2
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 25
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        tapView.frame = CGRect(x: 5, y: 5, width: frame.width/2 - 10, height: frame.height - 10)
        addSubview(tapView)
        addSubview(leftButton)
        addSubview(rightButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapButton(sender: UIButton) {
        switch sender {
        case leftButton:
            UIView.animate(withDuration: 0.25) {
                self.tapView.frame.origin.x = 5
            }
        case rightButton:
            UIView.animate(withDuration: 0.25) {
                self.tapView.frame.origin.x = self.frame.width / 2 + 5
            }
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func createButton(title: String, x: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: x, y: 0, width: frame.width/2, height: frame.height)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }
}
