import Foundation

enum RegistrationAnalyticsIdentity: Identity {
    case install
    case signUp
    case logIn
    
    var parameters: [String: NSObject] {
        switch self {
        case .install:
            return ["registration.install": Date().iso8601 as NSString]
        case .signUp:
            return ["registration.sign_up": Date().iso8601 as NSString]
        case .logIn:
            return ["registration.log_in": Date().iso8601 as NSString]
        }
    }
    
    var once: Bool {
        switch self {
        case .install:
            return true
        case .signUp:
            return true
        case .logIn:
            return false
        }
    }
    
}
