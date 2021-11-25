import UIKit

class collectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModel: CollectionViewmodel? {
        didSet { configureUI() }
    }
    
    public let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .lexendDecaBold(size: 16)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.locations = [0.6, 1.5]
        layer.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(3).cgColor]
        layer.cornerRadius = 5
        return layer
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        layer.addSublayer(gradientLayer)
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 5,
                          paddingBottom: 10,
                          paddingRight: 5)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = imageView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewmodel = viewModel else { return }
        
        imageView.sd_setImage(with: viewmodel.collectionImage)
        titleLabel.text = viewmodel.collectionTitle
    }
}
