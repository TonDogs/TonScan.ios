import Foundation

extension String {
    
    func makeURL() -> URL? {
        return URL(string: self)
    }
    
}

extension Optional where Wrapped == String {
    
    func makeURL() -> URL? {
        guard let self = self else {
            return nil
        }
        
        return self.makeURL()
    }
    
}
