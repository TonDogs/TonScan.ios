import UIKit

class SeparatorCollectionCell: UICollectionViewCell {
    
    enum SeparatorStyle {
        case solid
        case insets
        case none
    }
    
    var separatorStyle: SeparatorStyle = .none
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.04)
        
        return view
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        contentView.addSubview(separatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch separatorStyle {
        case .solid:
            separatorView.isHidden = false
            separatorView.pin.height(0.5).start().end().bottom()
        case .insets:
            separatorView.isHidden = false
            separatorView.pin.height(0.5).start(16.0).end(16.0).bottom()
        case .none:
            separatorView.isHidden = true
        }
    }

}
