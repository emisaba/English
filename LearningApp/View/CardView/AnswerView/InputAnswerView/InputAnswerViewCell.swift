import UIKit

class InputAnswerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public let label: UILabel = {
        let label = UILabel()
        label.font = .lexendDecaRegular(size: 16)
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        addSubview(label)
        label.anchor(top: topAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingTop: 8, paddingLeft: 8,
                     paddingBottom: 8, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
