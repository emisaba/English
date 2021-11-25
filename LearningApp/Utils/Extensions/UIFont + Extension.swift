import UIKit

extension UIFont {
    static func lexendDecaRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "LexendDeca-Regular", size: size) ?? .systemFont(ofSize: 20)
    }
    
    static func lexendDecaBold(size: CGFloat) -> UIFont {
        return UIFont(name: "LexendDeca-SemiBold", size: size) ?? .systemFont(ofSize: 20)
    }
}
