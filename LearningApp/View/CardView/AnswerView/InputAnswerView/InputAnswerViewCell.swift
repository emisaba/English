import UIKit

class InputAnswerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var labelText: String? {
        didSet {
            let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 14), .kern: 2]
            label.attributedText = NSAttributedString(string: labelText ?? "", attributes: attrubutes)
            label.textColor = .white
        }
    }
    
    public let label = UILabel()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 3
        layer.borderWidth = 1
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
