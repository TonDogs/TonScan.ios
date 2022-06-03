import UIKit

class SliderView: UISlider {
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.6
        }
    }

    var trackHeight: CGFloat = 2.0
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: trackHeight))
        super.trackRect(forBounds: bounds)
        
        return bounds
    }
    
}
