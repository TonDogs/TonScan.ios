import Firebase
import FirebaseAnalytics
import Amplitude
import StoreKit

protocol Identity {
    var parameters: [String: NSObject] {get}
    var once: Bool {get}
}

protocol AnalyticsEvent {
    var name: String {get}
    var parameters: [String: Any]? {get}
}

class Analytics {
    
    static let shared = Analytics()
    
    private let amplitude: Amplitude = .instance()
    private var launchIsTracked: Bool = false
    
    func setup(with application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        #if DEBUG
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #else
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        #endif
        amplitude.trackingSessionEvents = true
        amplitude.initializeApiKey("16fc4918bb54ad44cb8428a252f28d8a")
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackAppLaunch), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func identify() {
        if let userId = UserDefaults.standard.accountId {
            FirebaseAnalytics.Analytics.setUserID(String(userId))
            Crashlytics.crashlytics().setUserID(String(userId))
            amplitude.setUserId(String(userId), startNewSession: false)
        } else {
            FirebaseAnalytics.Analytics.setUserID(nil)
            Crashlytics.crashlytics().setUserID("")
            amplitude.setUserId(nil, startNewSession: false)
        }
    }
    
    func register(identity: Identity) {
        let identify = AMPIdentify()
        
        for (name, value) in identity.parameters {
            if identity.once {
                identify.setOnce(name, value: value)
            } else {
                identify.set(name, value: value)
            }
        }
        
        amplitude.identify(identify)
    }
    
    func register(event: AnalyticsEvent) {
        amplitude.logEvent(event.name, withEventProperties: event.parameters)
    }
    
    func handle(open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) {}
    
    func handle(continue userActivity: NSUserActivity) {}
    
    func handle(didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {}
    
    // MARK: - Purchases
    
    func trackPurchase(product: SKProduct) {}
    
    // MARK: - App life cycle
    
    @objc private func trackAppLaunch() {
        guard !launchIsTracked else {
            return
        }
        
        launchIsTracked = true
    }
    
}
