import UIKit
import WCLShineButton

class CheckListCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let checkBoxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(checkBoxView)
        checkBoxView.anchor(left: leftAnchor, paddingLeft: 20)
        checkBoxView.setDimensions(height: 25, width: 25)
        checkBoxView.centerY(inView: self)
    }
}
