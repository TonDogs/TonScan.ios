import Foundation
import UIKit

class PushNotificationProvider {
    
    func enableApplePush(deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02.2hhx", $1)})
        
        #if DEBUG
            let environment = "sandbox"
        #else
            let environment = "production"
        #endif
        
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        TonScanAPI.request(SettingsAPITarget.enableApplePush(token: deviceTokenString, deviceId: deviceId, environment: environment)) { result in
            do {
                let response = try result.get()
                log.info("Apple push was set: \(response.statusCode)")
            } catch {
                log.error("Can't set token: \(error)")
            }
        }
    }
    
}
