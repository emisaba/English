import UIKit
import ChameleonFramework

enum CollectionType {
    case user
    case download
}

protocol CategoryViewDelegate {
    func didSelectCategory(categoryType: CollectionType)
}

class CategoryView: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: CategoryViewDelegate?
    
    public var viewModel: CategoryViewModel? {
        didSet { configureViewModel() }
    }
    
    public var isStudyVC: Bool = false {
        didSet { configureUI() }
    }
    
    public var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    public var titleLabel = UILabel.createLabel(text: "", size: 25)
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        visualEffectView.alpha = 0.7
        return visualEffectView
    }()
    
    private lazy var userCategoryButton = UIButton.createImageButton(image: #imageLiteral(resourceName: "user"), target: self, action: #selector(didTapUserCategoryButton))
    private lazy var downloadCategoryButton = UIButton.createImageButton(image: #imageLiteral(resourceName: "import"), target: self, action: #selector(didTapDownloadCategoryButton))
    
    private let selectedBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.locations = [0.5, 1]
        layer.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.darkColor().withAlphaComponent(1).cgColor]
        return layer
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isStudyVC { return }
        
        gradientLayer.frame = frame
        addSubview(selectedBar)
        selectedBar.frame = CGRect(x: 25,
                                   y: frame.height - 40,
                                   width: 50,
                                   height: 10)
    }
    
    // MARK: - action
    
    @objc func didTapUserCategoryButton() {
        UIView.animate(withDuration: 0.25) {
            self.selectedBar.frame.origin.x = 25
        }
        delegate?.didSelectCategory(categoryType: .user)
    }
    
    @objc func didTapDownloadCategoryButton() {
        UIView.animate(withDuration: 0.25) {
            self.selectedBar.frame.origin.x = 105
        }
        delegate?.didSelectCategory(categoryType: .download)
    }
    
    // MARK: - Helpers
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 25), .kern: 8]
        titleLabel.attributedText = NSAttributedString(string: viewModel.categoryTitle ?? "", attributes: attrubutes)
    }
    
    func configureUI() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        imageView.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, right: rightAnchor, height: 100)
        titleLabel.centerY(inView: self)
        
        if isStudyVC == false {
            layer.addSublayer(gradientLayer)
            
            let selectCategoryStackView = UIStackView(arrangedSubviews: [userCategoryButton, downloadCategoryButton])
            selectCategoryStackView.distribution = .fillEqually
            selectCategoryStackView.spacing = 20

            addSubview(selectCategoryStackView)
            selectCategoryStackView.anchor(left: leftAnchor,
                                           bottom: bottomAnchor,
                                           paddingLeft: 20,
                                           paddingBottom: 50)
            selectCategoryStackView.setDimensions(height: 60, width: 140)
        }
    }
}
