import UIKit

extension UIApplication {
    
    var hasSafeArea: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
    
}
