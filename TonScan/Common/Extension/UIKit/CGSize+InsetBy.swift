import UIKit

extension CGSize {
    
    func inset(by insets: CGFloat) -> CGSize {
        return inset(by: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
    }
    
    func inset(by insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }
    
}
