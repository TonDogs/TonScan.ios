import UIKit

extension UIView {
    
    enum Axis: StringLiteralType {
        case x = "x"
        case y = "y"
    }
    
    func shake(on axis: Axis) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation." + axis.rawValue)
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-15, 15, -15, 15, -10, 10, -5, 5, 0]
        
        layer.add(animation, forKey: "shake")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
}
