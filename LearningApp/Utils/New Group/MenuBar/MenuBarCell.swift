import UIKit

class MenuBarCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .lexendDecaRegular(size: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        titleLabel.frame = bounds
        addSubview(titleLabel)
    }
    
    override var isHighlighted: Bool {
        didSet { titleLabel.font = isHighlighted ? .lexendDecaBold(size: 20) : .lexendDecaRegular(size: 16) }
    }
    
    override var isSelected: Bool {
        didSet { titleLabel.font = isSelected ? .lexendDecaBold(size: 20) : .lexendDecaRegular(size: 16) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
}
