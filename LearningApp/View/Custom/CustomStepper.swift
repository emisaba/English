import UIKit

protocol CustomStepperDelegate {
    func setMinus()
    func setPlus()
}

class CustomStepper: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomStepperDelegate?
    
    private let baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var minusButton = createButton(symbol: "-")
    private lazy var plusButton = createButton(symbol: "+")
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didChangeValue(sender: UIButton) {
        
        switch sender {
        case minusButton:
            delegate?.setMinus()
        case plusButton:
            delegate?.setPlus()
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(baseView)
        baseView.fillSuperview()
        
        let stackView = UIStackView(arrangedSubviews: [minusButton, plusButton])
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        baseView.addSubview(stackView)
        stackView.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 7,
                         paddingLeft: 7,
                         paddingBottom: 7,
                         paddingRight: 7)
    }
    
    func createButton(symbol: String) -> UIButton {
        let button = UIButton()
        button.setTitle(symbol, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(didChangeValue(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }
}
