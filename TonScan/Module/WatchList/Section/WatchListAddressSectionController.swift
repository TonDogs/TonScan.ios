import IGListKit
import SwipeCellKit

protocol WatchListAddressSectionControllerDelegate: AnyObject {
    func watchListAddressSectionController(_ controller: WatchListAddressSectionController, didToggleWatch wallet: WatchListAddressModel)
    func watchListAddressSectionController(_ controller: WatchListAddressSectionController, didToggleNotifications wallet: WatchListAddressModel)
    func watchListAddressSectionController(_ controller: WatchListAddressSectionController, changeName wallet: WatchListAddressModel)
}

class WatchListAddressSectionController: ListSectionController {
    
    weak var delegate: WatchListAddressSectionControllerDelegate?
    
    private var wallet: WatchListAddressModel!
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return WatchListAddressCell.cellSize(containerSize: collectionContext!.containerSize)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: WatchListAddressCell.self, for: self, at: index)
        cell.addressLabel.attributedText = wallet.address.raw.getTonLinkAddress(with: wallet.address.getWalletName())
        cell.addressLabel.onClick = { [weak self] label, detection in
            guard case .tag(let tag) = detection.type else { return }
            guard tag.name == "a", let address = tag.attributes["href"] else { return }
            
            self?.navigate(to: address)
        }
        
        cell.subtitleLabel.text = AgoDateFormatter.instance.string(for: wallet.lastTransactionTime)
        cell.balanceLabel.text = wallet.balance.tonCurrency
        cell.separatorView.isHidden = isLastSection
        cell.delegate = self
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is WatchListAddressModel)
        wallet = object as? WatchListAddressModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        navigate(to: wallet.address.raw)
    }
    
    private func navigate(to address: String) {
        let viewController = AddressViewController(address: wallet.address.raw)
        
        if let searchViewController = self.viewController as? SearchViewController {
            let navigationController = searchViewController.parent?.presentingViewController?.navigationController
            
            searchViewController.dismiss(animated: true) {
                navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            self.viewController?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

// MARK: - SwipeCollectionViewCellDelegate
extension WatchListAddressSectionController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let unwatch = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let self = self else { return }
            self.delegate?.watchListAddressSectionController(self, didToggleWatch: self.wallet)
        }
        unwatch.backgroundColor = UIColor(hex6: 0xFF3347)
        unwatch.image = R.image.walletUnwatch()
        
        let notification: SwipeAction
        switch wallet.notificationMode {
        case .all:
            notification = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
                guard let self = self else { return }
                self.wallet.notificationMode = .none
                self.delegate?.watchListAddressSectionController(self, didToggleNotifications: self.wallet)
            }
            notification.image = R.image.walletNotificationsDisable()
        case .none:
            notification = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
                guard let self = self else { return }
                self.wallet.notificationMode = .all
                self.delegate?.watchListAddressSectionController(self, didToggleNotifications: self.wallet)
            }
            notification.image = R.image.walletNotificationsEnable()
        }
        notification.backgroundColor = UIColor(hex6: 0xFBAF44)
        notification.hidesWhenSelected = true
        
        let edit = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let self = self else { return }
            self.delegate?.watchListAddressSectionController(self, changeName: self.wallet)
        }
        edit.image = R.image.walletEdit()
        edit.backgroundColor = UIColor(hex6: 0x735CE6)

        return [unwatch, notification, edit]
    }
    
}
