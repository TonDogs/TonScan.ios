import UIKit

enum DeviceAnalyticsIdentity: Identity {
    case common
    
    var parameters: [String: NSObject] {
        switch self {
        case .common:
            return [
                "device.preferred_languages": Locale.preferredLanguages as NSArray,
            ]
        }
    }
    
    var once: Bool {
        switch self {
        case .common:
            return false
        }
    }
    
}
