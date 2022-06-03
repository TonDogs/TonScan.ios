import UIKit

class RoundedCornerView: UIView {
    
    private var previousBounds: CGRect = .zero
    
    private var maskLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    var roundedCorners: UIRectCorner = [.topLeft, .topRight] {
        didSet {
            setNeedsLayout()
        }
    }
    
    var roundedRadii: CGSize = CGSize(width: 18.0, height: 18.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard previousBounds != bounds else {
            return
        }
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundedCorners, cornerRadii: roundedRadii)
        maskLayer.path = path.cgPath
        
        previousBounds = bounds
    }
}
