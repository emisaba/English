import UIKit

class CustomSlider: UISlider {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let tapPoint = touch.location(in: self)
        let fraction = Float(tapPoint.x / bounds.width)
        var newValue = (maximumValue - minimumValue) * fraction + minimumValue
        if newValue != value {
            
            let width = maximumValue - minimumValue
            let dividedWidth = width / 5
            
            if newValue < dividedWidth {
                newValue = minimumValue
            } else if newValue >= dividedWidth && newValue < dividedWidth * 2 {
                newValue = minimumValue + dividedWidth * 1.25
            } else if newValue >= dividedWidth && newValue < dividedWidth * 3 {
                newValue = minimumValue + dividedWidth * 2.5
            } else if newValue >= dividedWidth && newValue < dividedWidth * 4 {
                newValue = minimumValue + dividedWidth * 3.75
            } else if newValue >= dividedWidth && newValue < dividedWidth * 5 {
                newValue = maximumValue
            }
            
            value = newValue
        }
        return true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var wideBounds = bounds
        wideBounds.size.height += 60.0
        return wideBounds.contains(point)
    }
}
