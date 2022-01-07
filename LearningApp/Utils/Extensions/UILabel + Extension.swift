import UIKit

extension UILabel {
    static func createLabel(text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: size), .kern: 8]
        label.attributedText = NSAttributedString(string: text, attributes: attrubutes)
        return label
    }
}
