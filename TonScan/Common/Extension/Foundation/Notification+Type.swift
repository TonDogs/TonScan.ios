import Foundation

class NotificationCenterHolder {
    
    private let notificationCenter: NotificationCenter
    private var tokens: [NSObjectProtocol] = []
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    deinit {
        tokens.forEach({notificationCenter.removeObserver($0)})
    }
    
    func addObserver<T>(for type: T.Type, using block: @escaping(T) -> Void) {
        let token = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: String(describing: T.self)), object: nil, queue: nil) { notification in
            guard let object = notification.object as? T else {
                return
            }
            
            block(object)
        }
        
        tokens.append(token)
    }
    
}

extension NotificationCenter {
    
    func post<T>(_ object: T) {
        post(name: NSNotification.Name(rawValue: String(describing: T.self)), object: object, userInfo: nil)
    }
    
}
