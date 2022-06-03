import Moya

protocol TonScanAPITarget: TargetType {
    /// Indicate about needed a authorization.
    var needsAuthorization: Bool { get }
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? { get }
}

extension TonScanAPITarget {
    
    var headers: [String : String]? {
        #if DEBUG
        let deviceId = "TEST_DEVICE_ID"
        #else
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        #endif
        
        return [
            "Accept-Language": Bundle.main.applicationPreferredLanguage,
            "Content-Type": "application/json",
            "TimeZone-GMT": String(NSTimeZone.system.secondsFromGMT()),
            "device_id": deviceId
        ]
    }
    
    var baseURL: URL {
        let version = "api/v2"
        
        if Bundle.main.isSandbox, let url = UserDefaults.standard.developerAPIURL.makeURL() {
            return URL(string: version, relativeTo: url)!
        } else {
            return URL(string: version, relativeTo: TonScanAPI.apiURL)!
        }
    }
    
    var sampleData: Data {
        // Change to real structure on each request for tests
        return Data()
    }
    
    var task: Task {
        guard let parameters = parameters else {
            return .requestPlain
        }
        
        let encoding: ParameterEncoding = {
            switch method {
            case .post:
                return JSONEncoding.default
            default:
                return URLEncoding(destination: .queryString)
            }
        }()
        
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
}
