import Moya

protocol TonScanAPIAuthorizationPluginDelegate: AnyObject {
    func invalidCredentials(plugin: TonScanAPICredentialPlugin?)
}

struct TonScanAPICredentialPlugin: PluginType {

    let tokenClosure: () -> String?

    weak var delegate: TonScanAPIAuthorizationPluginDelegate?

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard request.url != nil, let token = tokenClosure(), let multiTarget = target as? MultiTarget, case let MultiTarget.target(targetType) = multiTarget, let target = targetType as? TonScanAPITarget, target.needsAuthorization else {
                return request
        }

        var request = request
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result, isInvalidCredentials(in: response), tokenClosure() != nil {
            DispatchQueue.main.async {
                self.delegate?.invalidCredentials(plugin: self)
            }
        }
    }

    private func isInvalidCredentials(in response: Response) -> Bool {
        return response.statusCode == 401
    }

}
