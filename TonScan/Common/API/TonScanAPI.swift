import Moya
import Alamofire

let TonScanAPI = APIProvider(callbackQueue: APIProvider.callbackQueue, plugins: APIProvider.plugins)
let TonScanStubAPI = APIProvider(stubClosure: MoyaProvider.immediatelyStub,
                               callbackQueue: APIProvider.callbackQueue,
                               plugins: APIProvider.plugins)

struct APIResponseError: Error, Codable {
    let code: Int
    let message: String?
}

class APIProvider: MoyaProvider<MultiTarget> {

    let apiURL = URL(string: "https://tonscan.app")!
    
    @discardableResult
    func request(_ target: TonScanAPITarget, completion: @escaping Completion) -> Cancellable {
        return self.request(MultiTarget(target)) { result in
            do {
                let response = try result.get()
                
                if let error = try? response.decode(APIResponseError.self, atKeyPath: "error") {
                    throw error
                }
                
                if let json = (try response.mapJSON() as? NSDictionary)?["response"] {
                    completion(.success(Response(statusCode: response.statusCode, data: try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed))))
                } else {
                    throw APIResponseError(code: -1, message: nil)
                }
            } catch {
                completion(.failure(error as? MoyaError ?? .underlying(error, nil)))
            }
        }
    }

    private static func JSONResponseDataFormatter(_ data: Data) -> String {
        let placeholder = "## Cannot map data to String ##"

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

            return String(data: data, encoding: .utf8) ?? placeholder
        } catch {
            return String(data: data, encoding: .utf8) ?? placeholder
        }
    }

    private static func logOutput(target: TargetType, items: [String]) {
        for item in items {
            log.verbose(item)
        }
    }

    fileprivate static let plugins: [PluginType] = [
        NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(formatter: NetworkLoggerPlugin.Configuration.Formatter(requestData: JSONResponseDataFormatter, responseData: JSONResponseDataFormatter), output: logOutput, logOptions: .verbose)),
        TonScanAPICachePlugin(),
    ]

    static let callbackQueue = DispatchQueue(label: "ton.express.scanner.api.queue", qos: .utility, attributes: .concurrent)
}
