import UIKit

class BlurButton: UIButton {
    
    private let blurAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    private(set) lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.isUserInteractionEnabled = false
        view.effect = UIBlurEffect(style: .dark)
       
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        insertSubview(blurView, at: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2.0
        layer.masksToBounds = true
        
        sendSubviewToBack(blurView)
        blurView.frame = bounds
    }
    
}
