import Foundation

extension BinaryInteger {
    
    var kFormatted: String {
        return Double(self).kFormatted
    }
    
}

extension FloatingPoint {
    
    var kFormatted: String {
        var string: String
        
        switch self {
        case 1_000_000...:
            string = String(format: "%.1fM", (self / 1_000_000) as! CVarArg)
        case 1000...:
            string = String(format: "%.1fK", (self / 1_000) as! CVarArg)
        default:
            string = String(format: "%.1f", self as! CVarArg)
        }
        
        return string.replacingOccurrences(of: ".0", with: "")
    }
    
}
