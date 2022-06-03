import Moya
import Alamofire

protocol TonScanAPICachePluginProtocol {
    var cachingIsEnabled: Bool {get}
}

class TonScanAPICachePlugin: PluginType {

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        guard let multiTarget = target as? MultiTarget, case let MultiTarget.target(target) = multiTarget,
              let target = target as? TonScanAPICachePluginProtocol & TargetType, target.cachingIsEnabled else {
            return result
        }
        
        guard let request = try? MoyaProvider.defaultEndpointMapping(for: multiTarget).urlRequest(),
              let url = request.url, let cacheKey = url.absoluteString.base64Encoded() else {
            return result
        }
        
        switch result {
        case .success(let response):
            CacheStorage(cacheKey: cacheKey).write(response.data)
            
            return result
        case .failure(let error):
            // https://github.com/Moya/Moya/issues/2059#issuecomment-770453004
            if let alamofireError = error.errorUserInfo["NSUnderlyingError"] as? Alamofire.AFError,
               let underlyingError = alamofireError.underlyingError as NSError?,
               [NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed].contains(underlyingError.code),
               let data = CacheStorage(cacheKey: cacheKey).read() {
                return .success(Response(statusCode: 200, data: data, request: nil, response: nil))
            } else {
                return result
            }
        }
    }
    
}

extension CachableTarget where Self: TargetType {
    var cacheKey: String {
        return self.path
    }
}

public protocol CachableTarget {
    var cachingEnabled: Bool { get }
    var cacheKey: String { get }
}

public class CacheStorage {
    
    private let cacheKey: String
  
    fileprivate lazy var storeUrl: URL? = {
        guard let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            assertionFailure("could not find storage path")
            return nil
        }
        
        return dir.appendingPathComponent(self.cacheKey)
    }()
    

    public init(cacheKey: String) {
        self.cacheKey = cacheKey
    }

    public func write(_ data: Data) {
        guard let storeUrl = self.storeUrl else {
            assertionFailure("Could not create store url")
            return
        }
        
        try? data.write(to: storeUrl)
    }
    
    public func read() -> Data? {
        guard let storeUrl = self.storeUrl else {
            assertionFailure("Could not create store url")
            return nil
        }
        
        let readData = try? Data(contentsOf: storeUrl)
        return readData
    }
    
}
