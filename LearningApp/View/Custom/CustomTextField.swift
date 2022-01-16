import UIKit

class CustomTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        tintColor = .white
        textColor = .white
        layer.cornerRadius = 5
        backgroundColor = UIColor.lightColor()
        
        attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                   attributes: [.font: UIFont.senobiMedium(size: 16),
                                                                .foregroundColor: UIColor.white.withAlphaComponent(0.3)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
