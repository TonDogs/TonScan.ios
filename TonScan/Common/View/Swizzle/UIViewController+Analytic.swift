import UIKit

extension UIViewController {
    
    static let navigationAnalyticsInit: Void = {
       guard let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidAppear)),
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(spoki_viewDidAppear)) else {
            return
        }
        
       method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    @objc func spoki_viewDidAppear(_ animated: Bool) {
        spoki_viewDidAppear(animated)
        
        Analytics.shared.register(event: NavigationAnalyticsEvent.view(name: String(describing: type(of: self))))
    }
    
}
