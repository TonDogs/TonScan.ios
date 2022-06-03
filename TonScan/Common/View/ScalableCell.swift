import UIKit

class ScalableCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                let scale: CGFloat = self.isHighlighted ? 0.97 : 1.0
                self.layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
            }, completion: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                let scale: CGFloat = self.isSelected ? 0.97 : 1.0
                self.layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
            }, completion: nil)
        }
    }
    
}
