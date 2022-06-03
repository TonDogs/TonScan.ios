import IGListDiffKit

class FeedItemModel: Codable {
    
    class Fee: Codable {
        let total: Int
        let otherFee: Int
        let storageFee: Int
    }
    
    class Message: Codable {
        enum MessageType: String, Codable {
            case `in`
            case out
        }
        
        class Fee: Codable {
            let forward: Int
            let ihr: Int
        }
        
        class Message: Codable {
            enum MessageType: String, Codable {
                case text
                case raw
            }
            
            let type: MessageType
            let body: String?
        }
        
        let type: MessageType
        let source: WatchListAddressModel.Address
        let destination: WatchListAddressModel.Address
        let value: String
        let fee: Fee
        let message: Message
    }
    
    let address: WatchListAddressModel.Address
    let utime: Date
    let logicTime: String
    let hash: String
    let fee: Fee
    let messages: [Message]
    
    var amount: Double {
        return messages.reduce(0.0, { x, message in
            if let value = Double(message.value) {
                switch message.type {
                case .in:
                    return x + value
                case .out:
                    return x - value
                }
            } else {
                return x
            }
        })
    }
    
    var nonEmptyMessages: [Message] {
        messages.filter({!$0.source.raw.isEmpty})
    }
    
    var recipient: String {
        if let message = nonEmptyMessages.first, nonEmptyMessages.allSatisfy({$0.source.raw == message.source.raw}) {
            return message.source.raw
        } else {
            return String(nonEmptyMessages.count)
        }
    }
    
    var sender: String {
        if let message = nonEmptyMessages.first, nonEmptyMessages.allSatisfy({$0.destination.raw == message.destination.raw}) {
            return message.destination.raw
        } else {
            return String(nonEmptyMessages.count)
        }
    }
    
    var type: Message.MessageType {
        return nonEmptyMessages.allSatisfy({$0.type == .in}) ? .in : .out
    }
    
}

// MARK: - ListDiffable
extension FeedItemModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        hash as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }

        return hash == object.hash
    }
    
}
