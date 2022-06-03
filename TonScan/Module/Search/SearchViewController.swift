import IGListKit
import Moya

class SearchViewController: UIViewController {
    
    enum State {
        case loading, normal, loadingFailed
    }
    
    private var mainView: SearchView {
        return view as! SearchView
    }
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.setPositionAdjustment(UIOffset(horizontal: 8.0, vertical: 0.0), for: .search)
        controller.searchBar.searchTextField.layer.cornerRadius = 18.0
        controller.searchBar.searchTextField.layer.masksToBounds = true
        
        return controller
    }()
    
    private var address: String?
    private var wallet: WatchListAddressModel?
    private let provider = SearchProvider()
    private var state: State = .loading
    
    override func loadView() {
        view = SearchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAdapter()
    }
    
    private func setupAdapter() {
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    @objc private func load() {
        guard let address = address else {
            return
        }
        
        provider.load(address: address) { [weak self] result in
            guard let self = self, address == self.address else { return }
            
            switch result {
            case .success(let wallet):
                self.wallet = wallet
                self.state = .normal
            case .failure(let error):
                if let error = error as? MoyaError {
                    if case MoyaError.underlying(let error, _) = error, let error = error as? APIResponseError, error.code == 500 {
                        self.state = .normal
                    } else {
                        self.state = .loadingFailed
                    }
                } else {
                    self.state = .loadingFailed
                }
            }
            
            self.adapter.performUpdates(animated: true)
        }
    }
    
    @objc private func openWallets() {
        navigationController?.pushViewController(WatchListViewController(), animated: true)
    }
    
    @objc private func openSettings() {}
}

// MARK: - ListAdapterDataSource
extension SearchViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let wallet = wallet else { return [] }
        return [wallet]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return WatchListAddressSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        switch state {
        case .normal:
            let view = EmptyView()
            view.imageView.image = R.image.emptyViewLogoSad()
            view.titleLabel.text = R.string.localizable.searchEmptyTitle()
            view.subtitleLabel.text = R.string.localizable.searchEmptySubtitle()
            view.actionButton.isHidden = true
            
            return view
        case .loading:
            return EmptyLoadingView()
        case .loadingFailed:
            let view = EmptyView()
            view.imageView.image = R.image.emptyViewLogoSad()
            view.titleLabel.text = R.string.localizable.commonLoadingFailedTitle()
            view.subtitleLabel.text = R.string.localizable.commonLoadingFailedSubtitle()
            view.actionButton.setTitle(R.string.localizable.commonLoadingFailedAction(), for: .normal)
            view.actionButton.addTarget(self, action: #selector(load), for: .touchUpInside)
            
            return view
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        address = nil
        wallet = nil
        state = .loading
        adapter.performUpdates(animated: true)
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        address = searchText.isBlank ? nil : searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        load()
    }
    
}
