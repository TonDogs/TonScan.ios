import UIKit

class AddressFollowCell: UICollectionViewCell {
    
    static func cellSize(containerSize: CGSize) -> CGSize {
        return CGSize(width: containerSize.width, height: 60.0)
    }
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        
        let imageToTitleSpace: CGFloat = 8
        button.contentEdgeInsets.right = imageToTitleSpace
        button.titleEdgeInsets.left = imageToTitleSpace
        button.titleEdgeInsets.right = -imageToTitleSpace
        
        return button
    }()
    
    let notificationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(followButton)
        contentView.addSubview(notificationsButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        notificationsButton.pin.top(16.0).end().size(44.0)
        followButton.pin.top(16.0).start().height(44.0).end(to: notificationsButton.edge.start).marginEnd(12.0)
    }
    
}

