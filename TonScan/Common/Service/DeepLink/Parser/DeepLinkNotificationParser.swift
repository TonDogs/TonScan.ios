import Foundation

class DeepLinkNotificationParser {
    
    func parse(_ userInfo: [AnyHashable : Any]) -> DeepLink? {
        guard let link = userInfo["link"] as? [String: Any],
              let type = link["type"] as? String else {
                return nil
        }
        
        switch type {
        case "address":
            guard let address = link["address"] as? String else {
                return nil
            }
    
            return .address(address)
        case "url":
            guard let url = (link["url"] as? String)?.makeURL() else {
                return nil
            }
            
            return .url(url)
        default:
            return nil
        }
    }
    
}
