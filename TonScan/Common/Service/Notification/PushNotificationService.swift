import UIKit
import UserNotifications

protocol PushNotificationServiceDelegate: AnyObject {
    func pushNotificationService(openSettings service: PushNotificationService)
}

class PushNotificationService: NSObject {
    
    weak var delegate: PushNotificationServiceDelegate?
    
    private(set) var authorizationStatus: AuthorizationStatus = .notDetermined
    private let provider = PushNotificationProvider()
    
    enum AuthorizationStatus {
        case notDetermined
        case denied
        case provisional
        case ephemeral
        case authorized
    }
    
    static let shared = PushNotificationService()
    
    override private init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func enableApplePush(deviceToken: Data) {
        provider.enableApplePush(deviceToken: deviceToken)
    }
    
    func update(completion: ((AuthorizationStatus) -> Void)? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.authorizationStatus = .authorized
            case .denied:
                self.authorizationStatus = .denied
            case .notDetermined:
                self.authorizationStatus = .notDetermined
            case .provisional:
                self.authorizationStatus = .provisional
            case .ephemeral:
                self.authorizationStatus = .ephemeral
            @unknown default:
                break;
            }
            
            DispatchQueue.main.async {
                completion?(self.authorizationStatus)
            }
        }
        
    }
    
    func registerIfPossible() {
        switch authorizationStatus {
        case .notDetermined:
            guard #available(iOS 12, *) else {
                return
            }
            
            registerForNotifications(types: [.provisional, .alert, .badge, .sound, .providesAppNotificationSettings]) { [weak self] _ in
                self?.registerIfPossible()
            }
        case .authorized, .provisional, .ephemeral:
            UIApplication.shared.registerForRemoteNotifications()
        case .denied:
            break
        }
    }

    func register(in viewController: UIViewController, completion: ((AuthorizationStatus) -> Void)? = nil) {
        switch authorizationStatus {
        case .authorized:
            completion?(authorizationStatus)
        case .notDetermined, .provisional, .ephemeral:
            if #available(iOS 12, *) {
                registerForNotifications(types: [.sound, .alert, .badge, .providesAppNotificationSettings], completion: completion)
            } else {
                registerForNotifications(types: [.sound, .alert, .badge], completion: completion)
            }
        case .denied:
            showNotificationSettingsAlert(in: viewController, completion: completion)
        }
    }
    
    private func showNotificationSettingsAlert(in viewController: UIViewController, completion: ((AuthorizationStatus) -> Void)? = nil) {
        let alertController = UIAlertController(title: "alert_push_title".localized, message: "alert_push_message".localized, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "alert_cancel_title".localized, style: .cancel) { _ in
            completion?(self.authorizationStatus)
        }
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "alert_open_settings_title".localized, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
            
            completion?(self.authorizationStatus)
        }
        
        alertController.addAction(openAction)
        
        viewController.present(alertController, animated: true)
    }
    
    private func registerForNotifications(types: UNAuthorizationOptions, completion: ((AuthorizationStatus) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: types) { granted, error in
            if let error = error {
                log.error("Can't enable notifications: \(error)")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.update { status in
                    completion?(status)
                }
            }
        }
    }
    
    func unregister() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        delegate?.pushNotificationService(openSettings: self)
    }
    
}
