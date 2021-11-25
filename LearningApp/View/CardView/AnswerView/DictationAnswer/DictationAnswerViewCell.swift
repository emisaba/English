import UIKit

class DictationAnswerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = .lexendDecaRegular(size: 18)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        textLabel.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
