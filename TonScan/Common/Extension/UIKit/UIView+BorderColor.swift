import UIKit

extension UIView {
    
    private struct AssociatedObjects {
        static var borderColor = "\(#file)+\(#line)"
    }
    
    var borderColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjects.borderColor) as? UIColor
        }
        set {
            layer.borderColor = newValue?.cgColor
            objc_setAssociatedObject(self, &AssociatedObjects.borderColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    static let borderColorInit: Void = {
       guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(traitCollectionDidChange)),
        let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(swizzled_traitCollectionDidChange)) else {
            return
        }
        
       method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    @objc func swizzled_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        swizzled_traitCollectionDidChange(previousTraitCollection)
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
    }
    
}
