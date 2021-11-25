import UIKit

struct Dimension {
    
    static var safeAreaTop: CGFloat = 0
    
    static var safeAreaTopHeight: CGFloat {
        get {
            return safeAreaTop
        }
        set(height) {
            safeAreaTop = height
        }
    }
}
