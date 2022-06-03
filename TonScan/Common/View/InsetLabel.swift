import UIKit

class InsetLabel: UILabel {
    
    var contentInsets: UIEdgeInsets = .zero
    
    override var intrinsicContentSize: CGSize {
        let insets = contentInsets
        let originalSize = super.intrinsicContentSize
        
        guard insets != .zero else {
            return originalSize
        }
        
        let width = originalSize.width + insets.right + insets.left
        let height = originalSize.height + insets.top + insets.bottom
        
        return CGSize(width: width, height: height)
    }
    
    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2.0
    }
    
}
