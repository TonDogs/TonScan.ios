import Foundation

extension Bundle {
    
    var applicationPreferredLanguage: String {
        return Bundle.preferredLocalizations(from: Bundle.main.localizations, forPreferences: Locale.preferredLanguages).first!
    }
    
    var isSandbox: Bool {
        return appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }
    
}
