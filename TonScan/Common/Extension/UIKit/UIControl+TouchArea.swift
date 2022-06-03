import UIKit

extension UIControl {

    private struct TouchAreaEdgeInsets {
        static var value = "\(#file)+\(#line)"
    }

    var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &TouchAreaEdgeInsets.value) as? NSValue {
                var edgeInsets = UIEdgeInsets.zero
                value.getValue(&edgeInsets)

                return edgeInsets
            } else {
                return UIEdgeInsets.zero
            }
        }

        set (newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: UIEdgeInsets.zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)

            objc_setAssociatedObject(self, &TouchAreaEdgeInsets.value, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    @objc open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if touchAreaEdgeInsets == .zero || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }

        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by: self.touchAreaEdgeInsets)

        return hitFrame.contains(point)
    }

    func increaseTouchArea(radius: CGFloat) {
        self.touchAreaEdgeInsets = UIEdgeInsets(top: -radius, left: -radius,
                                                bottom: -radius, right: -radius)
    }

}
