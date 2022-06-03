import UIKit

class AddressDetailCell: SeparatorCollectionCell {
    
    static func cellSize(containerSize: CGSize) -> CGSize {
        return CGSize(width: containerSize.width, height: 50.0)
    }
    
    let backgroundImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = R.color.secondaryText()
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        
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
    
    private func layout() {
        backgroundImageView.pin.all()
        subtitleLabel.pin.end(16.0).vCenter().sizeToFit()
        titleLabel.pin.start(16.0).vCenter().end(to: subtitleLabel.edge.start).marginEnd(8.0).sizeToFit(.width)
    }
    
}

