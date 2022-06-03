import Foundation

extension String {
    
    func sha256() -> String {
        return (data(using: .utf8, allowLossyConversion: true) ?? Data(utf8)).sha256()
    }
    
}
