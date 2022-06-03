import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            var attachments: [UNNotificationAttachment]  = []
            
            if let mutable = request.content.userInfo["mutable"] as? [String: Any] {
                for key in mutable.keys {
                    switch key {
                    case "image":
                        guard let image = mutable[key] as? String, let imageURL = URL(string: image) else {
                            preconditionFailure("Can't get image")
                        }
                        
                        guard let attachment = loadImage(url: imageURL) else {
                            preconditionFailure("Can't load image")
                        }
                        
                        attachments.append(attachment)
                    default:
                        preconditionFailure("Unknown type")
                    }
                }
            }
            
            bestAttemptContent.attachments = attachments
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func loadImage(url: URL) -> UNNotificationAttachment? {
        let name = url.lastPathComponent
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL.appendingPathComponent(name)
            
            let data = try Data(contentsOf: url)
            try data.write(to: fileURL)
            
            return try UNNotificationAttachment(identifier: name, url: fileURL, options: nil)
        } catch {
            return nil
        }
    }

}
