import Foundation

class AccountModel: Codable {
    enum Sex: Int, Codable {
        case unknown, female, male
    }

    let id: Int
    let firstName: String?
    let lastName: String?
    let sex: Sex
    
}
