import UIKit
import SafariServices

class DeepLinkManager {
    
    private var deeplink: DeepLink?
    
    private let notificationParser: DeepLinkNotificationParser
    private let universalParser: DeepLinkUniversalParser
    
    init(notificationParser: DeepLinkNotificationParser = DeepLinkNotificationParser(), universalParser: DeepLinkUniversalParser = DeepLinkUniversalParser()) {
        self.notificationParser = notificationParser
        self.universalParser = universalParser
    }
    
    @discardableResult
    func handle(_ userInfo: [AnyHashable: Any]) -> Bool {
        guard let deeplink = notificationParser.parse(userInfo) else {
            return false
        }
        
        self.deeplink = deeplink
        return true
    }
    
    @discardableResult
    func handle(_ url: URL) -> Bool {
        guard let deeplink = universalParser.parse(url) else {
            return false
        }
        
        self.deeplink = deeplink
        return true
    }
    
    @discardableResult
    func handle(_ userActivity: NSUserActivity) -> Bool {
        guard let deeplink = universalParser.parse(userActivity) else {
            return false
        }
        
        self.deeplink = deeplink
        return true
    }
    
    func set(deeplink: DeepLink) {
        self.deeplink = deeplink
    }
    
    func getDeepLink() -> DeepLink? {
        return deeplink
    }
    
    func removeDeepLink() {
        deeplink = nil
    }
    
    func routeIfNeeded() {
        guard let deeplink = getDeepLink() else {
            return
        }
        
        removeDeepLink()
        
        switch deeplink {
        case .address(let address):
            guard let navigationController = UIApplication.shared.mainWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            navigationController.dismiss(animated: true) {
                navigationController.pushViewController(AddressViewController(address: address), animated: true)
            }
        case .url(let url):
            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { success in
                guard !success, let rootViewController = UIApplication.shared.mainWindow?.rootViewController else {
                    return
                }
                
                rootViewController.dismiss(animated: true) {
                    rootViewController.present(SFSafariViewController(url: url), animated: true)
                }
            }
        }
    }
    
}
