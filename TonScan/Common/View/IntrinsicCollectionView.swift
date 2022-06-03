import UIKit

class IntrinsicCollectionView: UICollectionView {
    
    var minimumIntrinsicHeight: CGFloat = 0.0
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height > 0 ? contentSize.height : minimumIntrinsicHeight)
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
}
