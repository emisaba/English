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
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .lexendDecaBold(size: 25)
        label.textColor = .white
        return label
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        visualEffectView.alpha = 0.7
        return visualEffectView
    }()
    
    private lazy var userCategoryButton = createButton()
    private lazy var downloadCategoryButton = createButton()
    
    private let selectedBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 5
        return view
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
        
        addSubview(selectedBar)
        selectedBar.frame = CGRect(x: 25,
                                   y: frame.height - 10,
                                   width: 50,
                                   height: 10)
    }
    
    // MARK: - action
    
    @objc func selectCategory(sender: UIButton) {
        
        switch sender {
        case userCategoryButton:
            UIView.animate(withDuration: 0.25) {
                self.selectedBar.frame.origin.x = 25
            }
            delegate?.didSelectCategory(categoryType: .user)
            
        case downloadCategoryButton:
            UIView.animate(withDuration: 0.25) {
                self.selectedBar.frame.origin.x = 125
            }
            delegate?.didSelectCategory(categoryType: .download)
            
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        titleLabel.text = viewModel.categoryTitle
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
            let selectCategoryStackView = UIStackView(arrangedSubviews: [userCategoryButton, downloadCategoryButton])
            selectCategoryStackView.distribution = .fillEqually

            addSubview(selectCategoryStackView)
            selectCategoryStackView.anchor(left: leftAnchor,
                                           bottom: bottomAnchor,
                                           paddingBottom: 20)
            selectCategoryStackView.setDimensions(height: 60, width: 200)
        }
    }
    
    func createButton() -> UIButton {
        let iv = UIImageView()
        iv.backgroundColor = .systemBlue
        iv.layer.cornerRadius = 30

        let button = UIButton()
        button.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        button.addSubview(iv)
        
        iv.setDimensions(height: 60, width: 60)
        iv.centerX(inView: button)
        
        return button
    }
}
