import UIKit

extension UIFont {
    static func lexendDecaRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "LexendDeca-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func lexendDecaBold(size: CGFloat) -> UIFont {
        return UIFont(name: "LexendDeca-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobiMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobiRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func rocknRollOneRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "RocknRollOne-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}
