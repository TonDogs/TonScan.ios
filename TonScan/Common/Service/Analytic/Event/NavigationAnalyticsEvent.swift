import Foundation

enum NavigationAnalyticsEvent: AnalyticsEvent {
    case view(name: String)
    
    var name: String {
        switch self {
        case .view:
            return "navigation.view"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .view(let name):
            return ["name": name]
        }
    }
    
}
