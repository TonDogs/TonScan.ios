import Moya

enum SettingsAPITarget {
    case enableApplePush(token: String, deviceId: String, environment: String)
}

extension SettingsAPITarget: TonScanAPITarget {

    var needsAuthorization: Bool {
        return true
    }

    var path: String {
        switch self {
        case .enableApplePush:
            return "settings.enableApplePush"
        }
    }

    var method: Moya.Method {
        switch self {
        case .enableApplePush:
            return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .enableApplePush(let token, let deviceId, let environment):
            return ["token": token, "device_id": deviceId, "area": environment]
        }
    }

}
