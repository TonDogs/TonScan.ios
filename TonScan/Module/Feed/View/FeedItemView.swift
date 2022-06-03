import SnapKit

class FeedItemView: PopupContentView {
    
    let headerView = FeedItemHeaderView()
    
    let collectionView: UICollectionView = {
        let view = IntrinsicCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
        view.minimumIntrinsicHeight = 100.0
        view.alwaysBounceVertical = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = R.color.primaryBackground()
        
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
        }
    }
    
}

