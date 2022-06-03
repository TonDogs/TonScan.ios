import PinLayout
import Atributika
import SwipeCellKit

class WatchListAddressCell: SwipeCollectionViewCell {
    
    static func cellSize(containerSize: CGSize) -> CGSize {
        return CGSize(width: containerSize.width, height: 70.0)
    }
    
    private let iconImageView = UIImageView(image: R.image.walletIcon())
    
    let addressLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = R.color.primaryText()!
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = R.color.secondaryText()
        
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = R.color.primaryText()
        
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.04)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(separatorView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.pin.start(16.0).vCenter().sizeToFit()
        balanceLabel.pin.end(8.0).bottom(to: edge.vCenter).marginBottom(2.0).sizeToFit()
        
        addressLabel.pin.start(to: iconImageView.edge.end).marginStart(12.0)
            .bottom(to: edge.vCenter).marginBottom(1.0)
            .end(to: balanceLabel.edge.start)
            .marginEnd(12.0)
            .sizeToFit(.width)
        subtitleLabel.pin.start(to: iconImageView.edge.end).marginStart(12.0)
            .top(to: edge.vCenter).marginTop(1.0)
            .end(12.0)
            .sizeToFit(.width)
        
        separatorView.pin.height(0.5).start(16.0).end().bottom()
    }
    
}

