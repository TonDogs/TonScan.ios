import UIKit
import PinLayout
import Atributika

class FeedItemMessageCell: SeparatorCollectionCell {
    
    static func cellSize(containerSize: CGSize) -> CGSize {
        return CGSize(width: containerSize.width, height: 62.0)
    }
    
    let backgroundImageView = UIImageView()
    
    let typeImageView = UIImageView()
    
    let addressLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = R.color.primaryText()!
        
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = R.color.primaryText()
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = R.color.secondaryText()
        
        return label
    }()
    
    let feeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = R.color.secondaryText()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(typeImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(feeLabel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.pin.all()
        typeImageView.pin.start(16.0).vCenter().sizeToFit()
        amountLabel.pin.end(16.0).sizeToFit()
        feeLabel.pin.end(16.0).sizeToFit()
        if timeLabel.text.isBlank {
            addressLabel.pin.start(to: typeImageView.edge.end)
                .marginStart(12.0)
                .vCenter(to: typeImageView.edge.vCenter)
                .end(to: amountLabel.edge.start)
                .marginEnd(8.0)
                .sizeToFit(.width)
        } else {
            addressLabel.pin.start(to: typeImageView.edge.end)
                .marginStart(12.0)
                .bottom(to: typeImageView.edge.vCenter)
                .marginBottom(-1.0)
                .end(to: amountLabel.edge.start)
                .marginEnd(8.0)
                .sizeToFit(.width)
            timeLabel.pin.start(to: typeImageView.edge.end)
                .marginStart(12.0)
                .top(to: typeImageView.edge.vCenter)
                .marginTop(1.0)
                .end(to: amountLabel.edge.start)
                .marginEnd(8.0)
                .sizeToFit(.width)
        }
        amountLabel.pin.vCenter(to: addressLabel.edge.vCenter)
        feeLabel.pin.vCenter(to: timeLabel.edge.vCenter)
    }
    
}

