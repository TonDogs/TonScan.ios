import UIKit

extension CGSize {
    
    var inch3: Bool {
        return width == 320.0
    }
    
    var inch4: Bool {
        return width == 375.0 && height == 667.0
    }
    
}

extension UIScreen {
    
    var inch3: Bool {
        return bounds.size.inch3
    }
    
    var inch4: Bool {
        return bounds.size.inch4
    }
    
}
