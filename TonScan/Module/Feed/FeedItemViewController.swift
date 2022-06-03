import PanModal
import IGListKit

class FeedItemViewController: UIViewController {
    
    private var mainView: FeedItemView {
        return view as! FeedItemView
    }
    
    private let item: FeedItemModel
    private let selectedIndex: Int
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        
        return formatter
    }()
    
    init(item: FeedItemModel, selectedIndex: Int) {
        self.item = item
        self.selectedIndex = selectedIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = FeedItemView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
        setupAdapter()
    }
    
    private func setupHeader() {
        if selectedIndex > 0 {
            mainView.headerView.titleLabel.text = R.string.localizable.itemMessage()
            
            switch item.nonEmptyMessages[selectedIndex - 1].type {
            case .in:
                mainView.headerView.iconImageView.image = R.image.feedHeaderTypeIn()
            case .out:
                mainView.headerView.iconImageView.image = R.image.feedHeaderTypeOut()
            }
        } else {
            mainView.headerView.titleLabel.text = item.amount.tonCurrencySigned
        }
        
        mainView.headerView.subtitleLabel.text = dateFormatter.string(for: item.utime)
        mainView.headerView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setupAdapter() {
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension FeedItemViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [item]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return FeedItemDetailsSectionController(selectedIndex: selectedIndex)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

//MARK: - PanModalPresentable
extension FeedItemViewController: PopupPanModalPresentable {
    
    var panMainView: PopupContentViewProtocol {
        return mainView
    }
    
    var panScrollable: UIScrollView? {
        return mainView.collectionView
    }
    
}
