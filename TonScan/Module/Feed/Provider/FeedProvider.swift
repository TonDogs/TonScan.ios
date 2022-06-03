import Foundation

class FeedProvider {
    
    private let api: APIProvider
    
    let limit: Int = 30
    private(set) var paginationFinished: Bool = false
    
    private var offset: Int = 0 //
    private var isLoading: Bool = false
    private var transaction: FeedItemModel?
    
    init(api: APIProvider = TonScanAPI) {
        self.api = api
    }
    
    func load(lastTransaction: FeedItemModel?, completion: @escaping(Result<[FeedItemModel], Error>) -> Void) {
        guard (!paginationFinished && !isLoading) || lastTransaction == nil else {
            return
        }
        
        isLoading = true
        transaction = lastTransaction
        
        let lt = lastTransaction?.logicTime
        let hash = lastTransaction?.hash
        
        //
        if lastTransaction == nil {
            offset = 0
        }
        
        let offset = offset
        //
        
        api.request(FeedAPITarget.get(limit: limit, offset: offset, lt: lt, hash: hash)) { [weak self] result in
            do {
                let response = try result.get()
                let items = try response.decode([FeedItemModel].self)
                
                DispatchQueue.main.async {
                    guard let self = self, self.offset == offset,
                    self.transaction?.logicTime == lt, self.transaction?.hash == hash else { return }
                    
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
    
}
