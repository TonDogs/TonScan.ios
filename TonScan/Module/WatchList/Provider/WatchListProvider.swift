import Foundation

class WatchListProvider {
    
    private let api: APIProvider
    
    let limit: Int = 30
    private(set) var paginationFinished: Bool = false
    
    private var offset: Int = 0
    private var isLoading: Bool = false
    
    init(api: APIProvider = TonScanAPI) {
        self.api = api
    }
    
    func load(refresh: Bool = false, completion: @escaping(Result<[WatchListAddressModel], Error>) -> Void) {
        guard (!paginationFinished && !isLoading) || refresh else {
            return
        }
        
        isLoading = true
        
        if refresh {
            offset = 0
        }
        
        let offset = offset
        
        api.request(WatchListAPITarget.get(limit: limit, offset: offset)) { [weak self] result in
            do {
                let response = try result.get()
                let items = try response.decode([WatchListAddressModel].self)
                
                DispatchQueue.main.async {
                    guard let self = self, self.offset == offset else { return }
                    
                    self.offset += self.limit
                    self.paginationFinished = items.count < self.limit
                    self.isLoading = false
                    
                    completion(.success(items))
                }
            } catch {
                log.error("Can't load feed: \(error)")
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                    completion(.failure(error))
                }
            }
        }
    }
    
    func watch(address: String, notificationMode: WatchListAddressModel.NotificationMode) {
        api.request(AddressAPITarget.watch(address: address, notificationMode: notificationMode.rawValue)) { result in
            switch result {
            case .success:
                log.verbose("Watched: \(address)")
            case .failure:
                log.verbose("Can't unwatch: \(address)")
            }
        }
    }
    
    func unwatch(address: String) {
        api.request(AddressAPITarget.unwatch(address: address)) { result in
            switch result {
            case .success:
                log.verbose("Unwatched: \(address)")
            case .failure:
                log.verbose("Can't unwatch: \(address)")
            }
        }
    }
    
    func setCustomAlias(_ title: String?, address: String) {
        api.request(AddressAPITarget.setCustomAlias(title: title, address: address)) { result in
            switch result {
            case .success:
                log.verbose("Set custom alias: \(address)")
            case .failure:
                log.verbose("Can't unwatch: \(address)")
            }
        }
    }
    
}
