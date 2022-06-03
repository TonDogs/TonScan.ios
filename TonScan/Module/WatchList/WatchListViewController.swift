import IGListKit

class WatchListViewController: UIViewController {
    
    enum State {
        case loading, normal, loadingFailed
    }
    
    private var mainView: WatchListView {
        return view as! WatchListView
    }
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.setPositionAdjustment(UIOffset(horizontal: 8.0, vertical: 0.0), for: .search)
        controller.searchBar.searchTextField.layer.cornerRadius = 18.0
        controller.searchBar.searchTextField.layer.masksToBounds = true
        
        return controller
    }()
    
    private var items: [WatchListAddressModel] = []
    private let provider = WatchListProvider()
    private var state: State = .loading
    
    override func loadView() {
        view = WatchListView()
        title = R.string.localizable.watchListTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupNavigationBar()
        setupRefreshControl()
        setupAdapter()
        load(refresh: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        
        provider.load(refresh: refresh) { [weak self] result in
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
    
    @objc private func openWallets() {
        navigationController?.pushViewController(WatchListViewController(), animated: true)
    }
    
    @objc private func openSettings() {}
}

// MARK: - ListAdapterDataSource
extension WatchListViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = WatchListAddressSectionController()
        controller.displayDelegate = self
        controller.delegate = self
        
        return controller
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        switch state {
        case .normal:
            let view = EmptyView()
            view.imageView.image = R.image.emptyViewLogoNormal()
            view.titleLabel.text = R.string.localizable.feedEmptyTitle()
            view.subtitleLabel.text = R.string.localizable.feedEmptySubtitle()
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
            view.actionButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
            
            return view
        }
    }
    
}

// MARK: - ListDisplayDelegate
extension WatchListViewController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        loadIfNeeded(for: sectionController.section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}

// MARK: - WatchListAddressSectionControllerDelegate
extension WatchListViewController: WatchListAddressSectionControllerDelegate {
    
    func watchListAddressSectionController(_ controller: WatchListAddressSectionController, didToggleWatch wallet: WatchListAddressModel) {
        guard let index = items.firstIndex(where: {$0.address.raw == wallet.address.raw}) else { return }
        provider.unwatch(address: wallet.address.raw)
        items.remove(at: index)
        adapter.performUpdates(animated: true)
    }
    
    func watchListAddressSectionController(_ controller: WatchListAddressSectionController, didToggleNotifications wallet: WatchListAddressModel) {
        if wallet.notificationMode == .all {
            PushNotificationService.shared.register(in: self)
        }
        
        provider.watch(address: wallet.address.raw, notificationMode: wallet.notificationMode)
    }
    
    func watchListAddressSectionController(_ controller: WatchListAddressSectionController, changeName wallet: WatchListAddressModel) {
        let viewController = UIAlertController(title: "Alias", message: "An alias lets you create a short name for an address.", preferredStyle: .alert)
        
        viewController.addTextField { textField in
            textField.placeholder = "Set alias"
            textField.text = wallet.address.customAlias
        }
        
        viewController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak viewController] action in
            guard let self = self, let viewController = viewController,
                  let textField = viewController.textFields?.first else { return }
            let title = textField.text.isBlank ? nil : textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            wallet.address.customAlias = title
            self.provider.setCustomAlias(title, address: wallet.address.raw)
            self.adapter.reloadObjects([wallet])
        })
        
        viewController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(viewController, animated: true)
    }
    
}
