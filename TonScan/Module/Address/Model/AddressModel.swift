import IGListDiffKit

class AddressModel: Codable {
    
    class Wallet: Codable, Equatable {
        static func == (lhs: AddressModel.Wallet, rhs: AddressModel.Wallet) -> Bool {
            return lhs.address == rhs.address && lhs.balance == rhs.balance && lhs.state == rhs.state
        }
        
        enum State: String, Codable {
            case active
            case frozen
            case uninitialized
        }
        
        struct Currency: Codable {
            let usd: Double
            let rub: Double
        }
        
        let address: WatchListAddressModel.Address
        let balance: String
        let currency: Currency
        let state: State
        let type: String?
        var isWatching: Bool
        var notificationMode: WatchListAddressModel.NotificationMode
    }
    
    let wallet: Wallet!
    var transactions: [FeedItemModel]
    
}

// MARK: - ListDiffable
extension AddressModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        wallet.address.raw as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }

        return wallet == object.wallet
    }
    
}
