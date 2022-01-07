import UIKit

extension ItemViewController {
    
    // MARK: - Actions
    
    @objc func didTapSettingButton(sender: UIButton) {
        
        let sectionNumber = sender.tag
        
        let isOpend = sections[sectionNumber].isOpened
        sections[sectionNumber].isOpened.toggle()
        
        let rowsCount = 4
        var updateRows = [IndexPath]()
        
        for row in 0 ..< rowsCount {
            let indexOfUpdateRow = IndexPath(row: row, section: sectionNumber)
            updateRows.append(indexOfUpdateRow)
        }
        
        if isOpend {
            tableView.deleteRows(at: updateRows, with: .none)
        } else {
            tableView.insertRows(at: updateRows, with: .none)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func createButton(image: UIImage? = nil, title: String? = nil, closeButton: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .lexendDecaBold(size: 20)
        button.contentHorizontalAlignment = .left
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: closeButton ? #selector(didTapCloseButton) : #selector(didTapAddButton), for: .touchUpInside)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        
        return button
    }
    
    func createHeaderView(section: Int) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70)
        view.clipsToBounds = true
        
        let testTypeButton = UIButton()
        testTypeButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: sections[section].isOpened ? 90 : 70)
        testTypeButton.layer.borderWidth = 2
        testTypeButton.layer.borderColor = UIColor.white.cgColor
        testTypeButton.layer.cornerRadius = 20
        testTypeButton.addTarget(self, action: #selector(didTapTestTypeButton), for: .touchUpInside)
        testTypeButton.accessibilityLabel = sections[section].title
        view.addSubview(testTypeButton)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: 10, y: 15, width: 40, height: 40)
        icon.layer.cornerRadius = 20
        icon.clipsToBounds = true
        view.addSubview(icon)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        titleLabel.center.y = view.frame.height / 2
        titleLabel.textColor  = .white
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 16), .kern: 8]
        titleLabel.attributedText = NSAttributedString(string: sections[section].title, attributes: attrubutes)
        view.addSubview(titleLabel)
        
        let settingButton = UIButton()
        settingButton.frame = CGRect(x: view.frame.width - 50, y: 20, width: 30, height: 30)
        settingButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        settingButton.clipsToBounds = true
        settingButton.layer.cornerRadius = 20
        settingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        settingButton.tag = section
        view.addSubview(settingButton)
        
        return view
    }
}
