import PanModal
import SnapKit

protocol PopupContentViewProtocol {
    var contentView: UIView {get}
}

class PopupContentView: UIView, PopupContentViewProtocol {
    
    let contentView: UIView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
}

protocol PopupPanModalPresentable: PanModalPresentable {
    var panMainView: PopupContentViewProtocol {get}
}

// MARK: - PanModalPresentable
extension PopupPanModalPresentable {
    
    var longFormHeight: PanModalHeight {
        let targetSize = CGSize(width: UIScreen.main.bounds.width,
                                height: UIView.layoutFittingCompressedSize.height)
        if panMainView.contentView.frame.size.height > 0.0 {
            panMainView.contentView.frame.size.height = 1.0
            panMainView.contentView.layoutIfNeeded()
        }
        
        let systemLayoutSize = panMainView.contentView.systemLayoutSizeFitting(targetSize,
                                                                               withHorizontalFittingPriority: .required,
                                                                               verticalFittingPriority: .defaultLow)
        panMainView.contentView.frame.size = systemLayoutSize
        
        if let panScrollable = panScrollable {
            panScrollable.frame.size.width = systemLayoutSize.width
        }
        
        return .contentHeight(systemLayoutSize.height)
    }
    
    var cornerRadius: CGFloat {
        return 20.0
    }
    
    var panModalBackgroundColor: UIColor {
        return .black.withAlphaComponent(0.6)
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.allowUserInteraction]
    }
    
}
