import Foundation
import UIKit

extension NSTextAttachment {
    
    func setImage(_ image: UIImage?, font: UIFont? = nil) {
        self.image = image
        guard let image = image else { return }
        bounds.size = image.size
        
        if let font = font {
            bounds.origin.y = (font.capHeight - image.size.height) / 2.0
        }
    }
    
}
