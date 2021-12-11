import UIKit

class SelectedCategoryViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var category: String = "" {
        didSet { categoryLabel.text = category }
    }
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let checkMark: UILabel = {
        let label = UILabel()
        label.text = "✓"
        label.textColor = .systemPink
        label.isHidden = true
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(checkMark)
        checkMark.anchor(right: rightAnchor)
        checkMark.setDimensions(height: frame.height, width: frame.height)
        checkMark.centerY(inView: self)
        
        addSubview(categoryLabel)
        categoryLabel.anchor(left: leftAnchor,
                             right: checkMark.leftAnchor,
                             paddingLeft: 10,
                             paddingRight: 10,
                             height: frame.height)
        categoryLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMark.isHidden = selected ? false : true
    }
}
