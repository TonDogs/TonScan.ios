import UIKit
import Kingfisher
import Atributika

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let deepLinkManager = DeepLinkManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoggerService.setup()
        KingfisherManager.shared.defaultOptions = [.transition(.fade(0.2))]
        
        Analytics.shared.setup(with: application, launchOptions: launchOptions)
        Analytics.shared.identify()
        Analytics.shared.register(identity: RegistrationAnalyticsIdentity.install)
        Analytics.shared.register(identity: DeviceAnalyticsIdentity.common)
        
        UIView.borderColorInit
        UIViewController.navigationAnalyticsInit
        
        PushNotificationService.shared.registerIfPossible()
        
        let backgroundColor = R.color.primaryBackground()
        let titleTextAttributes = [AttributedStringKey.font: R.font.ttCommonsDemiBold(size: 21.0)!]
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = backgroundColor
            appearance.titleTextAttributes = titleTextAttributes
            appearance.setBackIndicatorImage(R.image.navigationBack(), transitionMaskImage: R.image.navigationBack())
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = backgroundColor
            UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
            UINavigationBar.appearance().backIndicatorImage = R.image.navigationBack()
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = R.image.navigationBack()
        }
        
        let appearance = UIBarButtonItemAppearance()
        appearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        UINavigationBar.appearance().standardAppearance.backButtonAppearance = appearance
        UINavigationBar.appearance().compactAppearance?.backButtonAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance?.backButtonAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = R.color.primaryBackground()
        window!.rootViewController = UINavigationController(rootViewController: FeedViewController())
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        deepLinkManager.routeIfNeeded()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Analytics.shared.handle(open: url, options: options)
        deepLinkManager.handle(url)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        deepLinkManager.handle(userActivity)
        Analytics.shared.handle(continue: userActivity)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationService.shared.enableApplePush(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error(error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Analytics.shared.handle(didReceiveRemoteNotification: userInfo)
        
        if application.applicationState == .inactive {
            deepLinkManager.handle(userInfo)
        }
        
        completionHandler(.noData)
    }
    
}
