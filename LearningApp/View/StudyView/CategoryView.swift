import UIKit
import ChameleonFramework

class CategoryView: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewmodel: CategoryViewModel? {
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
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        imageView.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, right: rightAnchor, height: 100)
        titleLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewmodel = viewmodel else { return }
        
        imageView.sd_setImage(with: viewmodel.imageUrl)
        titleLabel.text = viewmodel.categoryTitle
    }
}
