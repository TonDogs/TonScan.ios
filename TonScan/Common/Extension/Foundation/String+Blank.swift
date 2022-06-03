import Foundation

extension String {
    
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

extension Optional where Wrapped == String {
    
    var isBlank: Bool {
        guard let self = self else {
            return true
        }
        
        return self.isBlank
    }
    
}
