import UIKit

enum StretchedImageService: String {
    case feedItemHeaderBubbleBackground
    case feedHeaderFooterBackground
    case feedHeaderBackground
    case feedMiddleBackground
    case feedFooterBackground
    case addressActionBackground
    case addressActionStrokeBackground

    var image: UIImage? {
        let cache = Self.imageCache

        if let cachedImage = cache.object(forKey: imageCacheKey as NSString) {
            return cachedImage
        }
        
        guard let image = UIImage(named: imageName) else {
            assertionFailure("Can't find \(imageName) image")
            return nil
        }
        
        let stretchedImage = stretch(image)
        cache.setObject(stretchedImage, forKey: imageCacheKey as NSString)
        
        return stretchedImage
    }
    
    private static let imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ton.express.scanner.stretchedImageCache"
        
        return cache
    }()
    
    private var imageCacheKey: String {
        if #available(iOS 13.0, *) {
            return rawValue + String(UITraitCollection.current.userInterfaceStyle.rawValue)
        } else {
            return rawValue
        }
    }

    private var imageName: String {
        return rawValue
    }

    private func stretch(_ image: UIImage) -> UIImage {
        let center = CGPoint(x: image.size.width / 2.0, y: image.size.height / 2.0)
        let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
        
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
    
}
