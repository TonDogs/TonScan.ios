import Foundation

class AddressProvider {
    
    private let api: APIProvider
    
    let limit: Int = 30
    private(set) var paginationFinished: Bool = false
    
    private var isLoading: Bool = false
    private var transaction: FeedItemModel?
    
    init(api: APIProvider = TonScanAPI) {
        self.api = api
    }
    
    func load(address: String, lastTransaction: FeedItemModel?, completion: @escaping(Result<AddressModel, Error>) -> Void) {
        guard (!paginationFinished && !isLoading) || lastTransaction == nil else {
            return
        }
        
        isLoading = true
        transaction = lastTransaction
        
        let lt = lastTransaction?.logicTime
        let hash = lastTransaction?.hash
        
        api.request(AddressAPITarget.get(address: address, limit: limit, lt: lt, hash: hash)) { [weak self] result in
            do {
                let response = try result.get()
                let address = try response.decode(AddressModel.self)
                
                DispatchQueue.main.async {
                    guard let self = self, self.transaction?.logicTime == lt, self.transaction?.hash == hash else { return }
                    
                    self.paginationFinished = address.transactions.count < self.limit
                    self.isLoading = false
                    
                    completion(.success(address))
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
