import Foundation

extension Double {
    
    fileprivate struct Formatter {
        static let instance: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            
            return formatter
        }()
    }
    
    var negative: Double {
        return self == 0.0 ? self : -1.0 * self
    }
    
    var ton: Double {
        return self / 1_000_000_000.0
    }
    
    var tonFormatted: String {
        ton.currency
    }
    
    var currency: String {
        let formatted = Formatter.instance.string(from: self as NSNumber) ?? String(format: "%.2f", self)
        
        // Remove sign on zero case
        return formatted == "-0" ? "0" : formatted
    }
    
    var tonCurrency: String {
        return String(format: "%@ TON", tonFormatted)
    }
    
    var tonCurrencySigned: String {
        if self > 0 {
            return "+" + tonCurrency
        } else {
            return tonCurrency
        }
    }
    
}

extension String {
    
    var tonCurrency: String? {
        return Double(self)?.tonCurrency
    }
    
    var tonCurrencyNegative: String? {
        return Double(self)?.negative.tonCurrency
    }
    
    var tonCurrencySigned: String? {
        return Double(self)?.tonCurrencySigned
    }
    
}

extension Int {
    
    var negative: Int {
        return self == 0 ? self : -1 * self
    }
    
    var tonFormatted: String {
        return Double(self).tonFormatted
    }
    
    var tonCurrency: String {
        return Double(self).tonCurrency
    }
    
    var tonFeeFormatted: String {
        Double.Formatter.instance.maximumFractionDigits = 3
        let formatted = Double(self).tonFormatted
        Double.Formatter.instance.maximumFractionDigits = 2
        return formatted
    }
    
    var tonFormattedNegative: String {
        return Double(self).negative.tonFormatted
    }
    
}
