import UIKit

class CustomTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                   attributes: [.font: UIFont.lexendDecaRegular(size: 16),
                                                                .foregroundColor: UIColor.white])
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.lightColor()
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
