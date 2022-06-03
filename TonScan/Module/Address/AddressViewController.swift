import IGListKit

class AddressViewController: UIViewController {
    
    enum State {
        case loading, normal, loadingFailed
    }
    
    private var mainView: AddressView {
        return view as! AddressView
    }
    
    let address: String
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
    private var addressInformation: AddressModel?
    private let provider = AddressProvider()
    private var state: State = .loading
    
    init(address: String) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AddressView()
        title = R.string.localizable.addressAddress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupNavigationBar()
        setupRefreshControl()
        setupAdapter()
        load(refresh: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.navigationNotification(),
            style: .plain,
            target: self,
            action: #selector(openNotifications)
        )
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
        
        provider.load(address: address, lastTransaction: refresh ? nil : addressInformation?.transactions.last) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let addressInformation):
                if refresh {
                    self.addressInformation = addressInformation
                } else {
                    self.addressInformation?.transactions += addressInformation.transactions
                }
                
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
        guard !provider.paginationFinished, let addressInformation = addressInformation,
              index + 1 >= addressInformation.transactions.count - provider.limit / 2 else { return }
        load(refresh: false)
    }
    
    @objc private func reload() {
        load(refresh: true)
    }
    @objc private func openNotifications() {}
}

// MARK: - ListAdapterDataSource
extension AddressViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let addressInformation = addressInformation else { return [] }
        return [addressInformation] + addressInformation.transactions
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is AddressModel:
            let controller = AddressSectionViewController()
            controller.displayDelegate = self
            controller.delegate = self
            
            return controller
        case is FeedItemModel:
            let controller = FeedItemSectionController()
            controller.displayDelegate = self
            
            return controller
        default:
            preconditionFailure("Unknown model")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        switch state {
        case .normal:
            return nil
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
extension AddressViewController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        loadIfNeeded(for: sectionController.section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}

// MARK: - AddressSectionViewControllerDelegate
extension AddressViewController: AddressSectionViewControllerDelegate {
    
    func addressSectionViewController(_ controller: AddressSectionViewController, didToggleWatch address: AddressModel) {
        if address.wallet.isWatching {
            provider.watch(address: address.wallet.address.raw, notificationMode: .none)
        } else {
            provider.unwatch(address: address.wallet.address.raw)
        }
    }
    
    func addressSectionViewController(_ controller: AddressSectionViewController, didToggleNotifications address: AddressModel) {
        if address.wallet.notificationMode == .all {
            PushNotificationService.shared.register(in: self)
        }
        
        provider.watch(address: address.wallet.address.raw, notificationMode: address.wallet.notificationMode)
    }
    
    func addressSectionViewController(_ controller: AddressSectionViewController, changeName address: AddressModel, completion: @escaping(String?) -> Void) {
        let viewController = UIAlertController(title: R.string.localizable.addressAlias(), message: R.string.localizable.addressSetAliasDescription(), preferredStyle: .alert)
        
        viewController.addTextField { textField in
            textField.placeholder = R.string.localizable.addressSetAlias()
            textField.text = address.wallet.address.customAlias
        }
        
        viewController.addAction(UIAlertAction(title: R.string.localizable.commonOk(), style: .default) { [weak self, weak viewController] action in
            guard let self = self, let viewController = viewController,
                  let textField = viewController.textFields?.first else { return }
            let title = textField.text.isBlank ? nil : textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            address.wallet.address.customAlias = title
            self.provider.setCustomAlias(title, address: address.wallet.address.raw)
            
            completion(title)
        })
        
        viewController.addAction(UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel))
        
        present(viewController, animated: true)
    }
    
}
