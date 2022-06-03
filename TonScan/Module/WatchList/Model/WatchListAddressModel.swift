import IGListDiffKit

class WatchListAddressModel: Codable {
    class Address: Codable, Equatable {
        static func == (lhs: WatchListAddressModel.Address, rhs: WatchListAddressModel.Address) -> Bool {
            return lhs.raw == rhs.raw
        }
        
        let raw: String
        let systemAlias: String?
        var customAlias: String?
        
        func getWalletName() -> String {
            if let customAlias = customAlias {
                return customAlias
            }
            
            if let systemAlias = systemAlias {
                return systemAlias
            }
            
            return raw.tonTruncatedAddress
        }
    }
    
    enum NotificationMode: String, Codable, Equatable {
        case none
        case all
    }
    
    // let id: Int
    let address: Address
    let balance: String
    let lastTransactionTime: Date?
    var notificationMode: NotificationMode
}

// MARK: - ListDiffable
extension WatchListAddressModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return address.raw as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else { return false }
        return object.address.raw == address.raw
    }
    
}
