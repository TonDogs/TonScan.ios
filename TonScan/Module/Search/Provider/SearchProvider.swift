import Foundation

class SearchProvider {
    
    private let api: APIProvider
    
    init(api: APIProvider = TonScanAPI) {
        self.api = api
    }
    
    func load(address: String, completion: @escaping(Result<WatchListAddressModel, Error>) -> Void) {
        api.request(AddressAPITarget.search(address: address)) { result in
            do {
                let response = try result.get()
                let wallet = try response.decode(WatchListAddressModel.self)
                
                DispatchQueue.main.async {
                    completion(.success(wallet))
                }
            } catch {
                log.error("Can't load feed: \(error)")
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
