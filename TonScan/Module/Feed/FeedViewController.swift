import IGListKit

class FeedViewController: UIViewController {
    
    enum State {
        case loading, normal, loadingFailed
    }
    
    private var mainView: FeedView {
        return view as! FeedView
    }
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private lazy var searchController: UISearchController = {
        let searchResultsController = SearchViewController()
        
        let controller = UISearchController(searchResultsController: searchResultsController)
        controller.searchResultsUpdater = searchResultsController
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.setPositionAdjustment(UIOffset(horizontal: 8.0, vertical: 0.0), for: .search)
        controller.searchBar.searchTextField.layer.cornerRadius = 18.0
        controller.searchBar.searchTextField.layer.masksToBounds = true
        controller.searchBar.placeholder = R.string.localizable.feedSearchPlaceholder()
        
        return controller
    }()
    
    private var items: [FeedItemModel] = []
    private let provider = FeedProvider()
    private var state: State = .loading
    
    override func loadView() {
        view = FeedView()
        title = R.string.localizable.feedTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupRefreshControl()
        setupAdapter()
        load(refresh: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.navigationWallets(),
            style: .plain,
            target: self,
            action: #selector(openWallets)
        )
        /*
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.navigationSettings(),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
         */
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        mainView.collectionView.refreshControl = refreshControl
    }
    
    private func setupAdapter() {
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    private func load(refresh: Bool = false) {
        state = .loading
        adapter.performUpdates(animated: true)
        
        provider.load(lastTransaction: refresh ? nil : items.last) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                if refresh { self.items = items } else { self.items += items }
                self.state = .normal
            case .failure:
                self.state = .loadingFailed
            }
            
            if refresh {
                self.mainView.collectionView.refreshControl?.endRefreshing()
            }
            
            self.adapter.performUpdates(animated: true)
        }
    }
    
    private func loadIfNeeded(for index: Int) {
        guard !provider.paginationFinished, index + 1 >= items.count - provider.limit / 2 else { return }
        load(refresh: false)
    }
    
    @objc private func reload() {
        load(refresh: true)
    }
    
    @objc private func search() {
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc private func openWallets() {
        navigationController?.pushViewController(WatchListViewController(), animated: true)
    }
    
    @objc private func openSettings() {}
}

// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = FeedItemSectionController()
        controller.displayDelegate = self
        
        return controller
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        switch state {
        case .normal:
            let view = EmptyView()
            view.imageView.image = R.image.emptyViewLogoNormal()
            view.titleLabel.text = R.string.localizable.feedEmptyTitle()
            view.subtitleLabel.text = R.string.localizable.feedEmptySubtitle()
            view.actionButton.setTitle(R.string.localizable.feedEmptyAction(), for: .normal)
            view.actionButton.addTarget(self, action: #selector(search), for: .touchUpInside)
            
            return view
        case .loading:
            return EmptyLoadingView()
        case .loadingFailed:
            let view = EmptyView()
            view.imageView.image = R.image.emptyViewLogoSad()
            view.titleLabel.text = R.string.localizable.commonLoadingFailedTitle()
            view.subtitleLabel.text = R.string.localizable.commonLoadingFailedSubtitle()
            view.actionButton.setTitle(R.string.localizable.commonLoadingFailedAction(), for: .normal)
            view.actionButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
            
            return view
        }
    }
    
}

// MARK: - ListDisplayDelegate
extension FeedViewController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        loadIfNeeded(for: sectionController.section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
