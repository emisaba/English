import UIKit

struct ItemViewModel {
    private let rowType: RowType
    
    public var shouldHideJapanse: Bool {
        return rowType == .japaneseOffSwitch ? false : true
    }
    
    public var shouldHideSegment: Bool {
        return rowType == .testTypeSegment ? false : true
    }
    
    public var shoudlHideBorder: Bool {
        return rowType == .bottomSpace
    }
    
    public var borderHeight: CGFloat {
        return rowType == .underBorder ? 40 : 100
    }
    
    public var borderCornerRadius: CGFloat {
        return rowType == .underBorder ? 20 : 0
    }
    
    public var borderY: CGFloat {
        return rowType == .underBorder ? -20 : -10
    }
    
    init(rowType: RowType) {
        self.rowType = rowType
    }
}

enum RowType: CaseIterable {
    case topSpace
    case japaneseOffSwitch
    case testTypeSegment
    case underBorder
    case bottomSpace
}
