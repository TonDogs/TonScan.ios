import UIKit

extension UIApplication {
    
    var mainWindow: UIWindow? {
        (connectedScenes.first as? UIWindowScene)?.windows.first
    }
    
}
