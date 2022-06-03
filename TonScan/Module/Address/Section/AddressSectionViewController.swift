import IGListKit
import Kingfisher

protocol AddressSectionViewControllerDelegate: AnyObject {
    func addressSectionViewController(_ controller: AddressSectionViewController, didToggleWatch address: AddressModel)
    func addressSectionViewController(_ controller: AddressSectionViewController, didToggleNotifications address: AddressModel)
    func addressSectionViewController(_ controller: AddressSectionViewController, changeName address: AddressModel, completion: @escaping(String?) -> Void)
}

class AddressSectionViewController: ListSectionController {
    
    enum Section: Int, CaseIterable {
        case alias
        case address
        case balance
        case state
        case type
        case follow
    }
    
    weak var delegate: AddressSectionViewControllerDelegate?
    
    private var address: AddressModel!
    private let template = FeedItemDetailCell()
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 8.0, right: 16.0)
    }
    
    override func numberOfItems() -> Int {
        return Section.allCases.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        switch Section(rawValue: index)! {
        case .alias:
            return configure(cell: template, index: index).sizeThatFits(collectionContext!.containerSize.inset(by: inset))
        case .address:
            return configure(cell: template, index: index).sizeThatFits(collectionContext!.containerSize.inset(by: inset))
        case .balance:
            return configure(cell: template, index: index).sizeThatFits(collectionContext!.containerSize.inset(by: inset))
        case .state:
            return AddressDetailCell.cellSize(containerSize: collectionContext!.containerSize.inset(by: inset))
        case .type:
            return AddressDetailCell.cellSize(containerSize: collectionContext!.containerSize.inset(by: inset))
        case .follow:
            return AddressFollowCell.cellSize(containerSize: collectionContext!.containerSize.inset(by: inset))
        }
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch Section(rawValue: index)! {
        case .alias:
            return configure(cell: collectionContext!.dequeue(of: FeedItemDetailCell.self, for: self, at: index), index: index)
        case .address:
            return configure(cell: collectionContext!.dequeue(of: FeedItemDetailCell.self, for: self, at: index), index: index)
        case .balance:
            return configure(cell: collectionContext!.dequeue(of: FeedItemDetailCell.self, for: self, at: index), index: index)
        case .state:
            return configure(cell: collectionContext!.dequeue(of: AddressDetailCell.self, for: self, at: index), index: index)
        case .type:
            return configure(cell: collectionContext!.dequeue(of: AddressDetailCell.self, for: self, at: index), index: index)
        case .follow:
            return configure(cell: collectionContext!.dequeue(of: AddressFollowCell.self, for: self, at: index), index: index)
        }
    }
    
    @discardableResult private func configure(cell: FeedItemDetailCell, index: Int) -> FeedItemDetailCell {
        switch Section(rawValue: index)! {
        case .alias:
            cell.titleLabel.text = R.string.localizable.addressAlias()
            
            let attributedText: NSMutableAttributedString
            
            if let customAlias = address.wallet.address.customAlias {
                attributedText = NSMutableAttributedString(string: customAlias)
                cell.subtitleLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
                cell.subtitleLabel.textColor = .white
            } else {
                attributedText = NSMutableAttributedString(string: R.string.localizable.addressSetAlias())
                cell.subtitleLabel.font = .systemFont(ofSize: 17.0)
                cell.subtitleLabel.textColor = .white.withAlphaComponent(0.5)
            }
            
            let attachment = NSTextAttachment()
            attachment.setImage(R.image.addressAlias(), font: cell.subtitleLabel.font)
            
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(NSAttributedString(attachment: attachment))
            
            cell.subtitleLabel.attributedText = attributedText
            cell.backgroundImageView.image = StretchedImageService.feedHeaderBackground.image
        case .address:
            cell.titleLabel.text = R.string.localizable.addressAddress()
            cell.subtitleLabel.text = address.wallet.address.raw
            cell.backgroundImageView.image = StretchedImageService.feedMiddleBackground.image
        case .balance:
            cell.titleLabel.text = R.string.localizable.addressBalance()
            if let balance = Double(address.wallet.balance) {
                cell.subtitleLabel.text = balance.tonCurrency + " ≈ $" + address.wallet.currency.usd.currency
            } else {
                cell.subtitleLabel.text = nil
            }
            cell.subtitleLabel.textColor = R.color.primaryText()
            cell.backgroundImageView.image = StretchedImageService.feedMiddleBackground.image
        default:
            preconditionFailure("Unknown index")
        }
        
        cell.separatorStyle = index < numberOfItems() - 2 ? .insets : .none
        
        return cell
    }
    
    private func configure(cell: AddressDetailCell, index: Int) -> AddressDetailCell {
        switch Section(rawValue: index)! {
        case .state:
            cell.titleLabel.text = R.string.localizable.addressState()
            
            switch address.wallet.state {
            case .active:
                cell.subtitleLabel.text = R.string.localizable.addressActiveState()
                cell.subtitleLabel.textColor = UIColor(hex6: 0x27AE60)
            case .frozen:
                cell.subtitleLabel.text = R.string.localizable.addressFrozenState()
                cell.subtitleLabel.textColor = UIColor(hex6: 0xEB5757)
            case .uninitialized:
                cell.subtitleLabel.text = R.string.localizable.addressUninitializedState()
                cell.subtitleLabel.textColor = UIColor(hex6: 0x888888)
            }

            cell.backgroundImageView.image = StretchedImageService.feedMiddleBackground.image
        case .type:
            cell.titleLabel.text = R.string.localizable.addressContractType()
            cell.subtitleLabel.text = address.wallet.type ?? R.string.localizable.addressUnknownContractType()
            cell.subtitleLabel.textColor = R.color.primaryText()
            cell.backgroundImageView.image = StretchedImageService.feedFooterBackground.image
        default:
            preconditionFailure("Unknown index")
        }
        
        cell.separatorStyle = index < numberOfItems() - 2 ? .insets : .none
        
        return cell
    }
    
    @discardableResult private func configure(cell: AddressFollowCell, index: Int) -> AddressFollowCell {
        switch Section(rawValue: index)! {
        case .follow:
            if address.wallet.isWatching {
                UIView.performWithoutAnimation {
                    cell.followButton.setTitle(R.string.localizable.addressUnfollow(), for: .normal)
                    cell.followButton.layoutIfNeeded()
                }
                cell.followButton.setTitleColor(.white, for: .normal)
                cell.followButton.tintColor = .white
                cell.followButton.setImage(R.image.addressUnwatch(), for: .normal)
                cell.followButton.setBackgroundImage(StretchedImageService.addressActionStrokeBackground.image, for: .normal)
            } else {
                UIView.performWithoutAnimation {
                    cell.followButton.setTitle(R.string.localizable.addressFollow(), for: .normal)
                    cell.followButton.layoutIfNeeded()
                }
                cell.followButton.setTitleColor(UIColor(hex6: 0x151B23), for: .normal)
                cell.followButton.tintColor = UIColor(hex6: 0x151B23)
                cell.followButton.setImage(R.image.addressWatchIcon(), for: .normal)
                cell.followButton.setBackgroundImage(StretchedImageService.addressActionBackground.image, for: .normal)
            }
            
            cell.followButton.removeTarget(nil, action: nil, for: .touchUpInside)
            cell.followButton.addTarget(self, action: #selector(toggleWatch), for: .touchUpInside)
            
            switch address.wallet.notificationMode {
            case .all:
                cell.notificationsButton.setTitleColor(.white, for: .normal)
                cell.notificationsButton.tintColor = .white
                cell.notificationsButton.setImage(R.image.addressNotificationDisable(), for: .normal)
                cell.notificationsButton.setBackgroundImage(StretchedImageService.addressActionStrokeBackground.image, for: .normal)
            case .none:
                cell.notificationsButton.setTitleColor(UIColor(hex6: 0x151B23), for: .normal)
                cell.notificationsButton.tintColor = UIColor(hex6: 0x151B23)
                cell.notificationsButton.setImage(R.image.addressNotificationEnable(), for: .normal)
                cell.notificationsButton.setBackgroundImage(StretchedImageService.addressActionBackground.image, for: .normal)
            }
            
            cell.notificationsButton.removeTarget(nil, action: nil, for: .touchUpInside)
            cell.notificationsButton.addTarget(self, action: #selector(toggleNotifications), for: .touchUpInside)
        default:
            preconditionFailure("Unknown index")
        }
        
        return cell
    }
    
    @objc private func toggleWatch() {
        address.wallet.isWatching.toggle()
        
        if !address.wallet.isWatching {
            address.wallet.notificationMode = .none
        }
        
        if let cell = collectionContext?.cellForItem(at: Section.follow.rawValue, sectionController: self) as? AddressFollowCell {
            configure(cell: cell, index: Section.follow.rawValue)
        }
        
        delegate?.addressSectionViewController(self, didToggleWatch: address)
    }
    
    @objc private func toggleNotifications() {
        switch address.wallet.notificationMode {
        case .all:
            address.wallet.notificationMode = .none
        case .none:
            address.wallet.notificationMode = .all
        }
        
        if address.wallet.notificationMode == .all {
            address.wallet.isWatching = true
        }
        
        if let cell = collectionContext?.cellForItem(at: Section.follow.rawValue, sectionController: self) as? AddressFollowCell {
            configure(cell: cell, index: Section.follow.rawValue)
        }
        
        delegate?.addressSectionViewController(self, didToggleNotifications: address)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is AddressModel)
        address = object as? AddressModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        switch Section(rawValue: index)! {
        case .alias:
            delegate?.addressSectionViewController(self, changeName: address) { [weak self] name in
                guard let self = self else { return }
                self.collectionContext?.performBatch(animated: false, updates: { context in
                    context.reload(in: self, at: IndexSet(integer: 0))
                })
            }
        default:
            break
        }
    }
    
}
