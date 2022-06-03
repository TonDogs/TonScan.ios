import UIKit

class FeedItemDetailCell: SeparatorCollectionCell {
    
    let backgroundImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = R.color.secondaryText()
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = CopyableLabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subtitleLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
        subtitleLabel.textColor = .white
    }
    
    private func layout() {
        backgroundImageView.pin.all()
        titleLabel.pin.top(16.0).start(16.0).end(16.0).sizeToFit(.width)
        subtitleLabel.pin.start(16.0).end(16.0)
            .top(to: titleLabel.edge.bottom).marginTop(10.0)
            .bottom(16.0).sizeToFit(.width)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return CGSize(width: size.width, height: subtitleLabel.frame.maxY + 16.0)
    }
    
}

