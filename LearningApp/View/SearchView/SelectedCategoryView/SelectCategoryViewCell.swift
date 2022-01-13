import UIKit
import SDWebImage

class SelectedCategoryViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var viewModel: CategoryViewModel? {
        didSet { configureViewModel() }
    }
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        visualEffectView.alpha = 0.3
        return visualEffectView
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 22),
                                                         .foregroundColor: UIColor.white,
                                                         .kern: 2]
        categoryLabel.attributedText = NSAttributedString(string: viewModel.categoryTitle ?? "", attributes: attrubutes)

        backgroundImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
    
    func configureUI() {
        selectionStyle = .none
        backgroundColor = .extraLightGray()
        
        addSubview(backgroundImageView)
        backgroundImageView.anchor(top: topAnchor,
                                   left: leftAnchor,
                                   bottom: bottomAnchor,
                                   right: rightAnchor,
                                   paddingTop: 10,
                                   paddingLeft: 20,
                                   paddingBottom: 10,
                                   paddingRight: 20)
        
        backgroundImageView.addSubview(visualEffectView)
        visualEffectView.fillSuperview()

        addSubview(categoryLabel)
        categoryLabel.centerX(inView: self)
        categoryLabel.centerY(inView: self)
    }
}
