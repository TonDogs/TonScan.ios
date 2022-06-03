import Foundation
import WidgetKit
import CoreSpotlight

class DeepLinkUniversalParser {
    
    func parse(_ url: URL) -> DeepLink? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host, host == TonScanAPI.apiURL.host else {
                return nil
        }
        
        var pathComponents = components.path.components(separatedBy: "/")
        pathComponents.removeFirst() // the first component is empty
        
        guard let type = pathComponents.first else {
            return nil
        }
        
        switch type {
        default:
            return nil
        }
    }
    
    func parse(_ userActivity: NSUserActivity) -> DeepLink? {
        switch userActivity.activityType {
        default:
            return nil
        }
    }
    
    private func process(uniqueIdentifier: String) -> DeepLink? {
        switch uniqueIdentifier {
        default:
            return nil
        }
    }
    
}
