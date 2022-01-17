import UIKit

class ShowAnswerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var selectedCell: Bool = false
    
    private let underline: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.anchor(top: topAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingTop: 5, paddingLeft: 5,
                     paddingBottom: 5, paddingRight: 5)
        
        addSubview(underline)
        underline.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defaultUI(shouldShowAnswer: Bool, text: String) {
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaRegular(size: 16),
                                                         .foregroundColor: UIColor.redColor(),
                                                         .kern: 1]
        label.attributedText = NSAttributedString(string: text, attributes: attrubutes)
        label.isHidden = shouldShowAnswer ? false : true
    }
}
