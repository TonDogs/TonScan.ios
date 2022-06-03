import UIKit

class Button: UIButton {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        insertSubview(backgroundImageView, at: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sendSubviewToBack(backgroundImageView)
        backgroundImageView.frame = bounds
    }
    
}

