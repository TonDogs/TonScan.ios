import UIKit

class FeedItemHeaderView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 82.0)
    }
    
    let iconImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.ttCommonsDemiBold(size: 21.0)
        label.textColor = R.color.primaryText()
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = R.color.secondaryText()
        
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.increaseTouchArea(radius: 16.0)
        button.setImage(R.image.navigationPopupClose(), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(closeButton)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(snp.centerY).offset(-2.0)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.centerY).offset(2.0)
            make.centerX.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16.0)
        }
    }
    
}

