import IGListKit
import Atributika

class AgoDateFormatter {
    static let instance: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter
    }()
}

class FeedItemSectionController: ListSectionController {
    
    private var item: FeedItemModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    }
    
    override func numberOfItems() -> Int {
        return item.nonEmptyMessages.count + 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let containerSize = collectionContext!.containerSize.inset(by: inset)
        
        switch index {
        case 0:
            return FeedItemHeaderCell.cellSize(containerSize: containerSize)
        default:
            return FeedItemMessageCell.cellSize(containerSize: containerSize)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: FeedItemMessageCell.self, for: self, at: index)
        
        switch index {
        case 0 where numberOfItems() == 1:
            cell.backgroundImageView.image = StretchedImageService.feedHeaderFooterBackground.image
            cell.separatorStyle = .none
        case 0:
            cell.backgroundImageView.image = StretchedImageService.feedHeaderBackground.image
            cell.separatorStyle = .solid
        case numberOfItems() - 1:
            cell.backgroundImageView.image = StretchedImageService.feedFooterBackground.image
            cell.separatorStyle = .none
        default:
            cell.backgroundImageView.image = StretchedImageService.feedMiddleBackground.image
            cell.separatorStyle = .solid
        }
        
        switch index {
        case 0:
            switch item.type {
            case .in:
                cell.typeImageView.image = R.image.feedHeaderTypeIn()
                cell.feeLabel.text = nil
            case .out:
                cell.typeImageView.image = R.image.feedHeaderTypeOut()
                cell.feeLabel.text = item.fee.total.negative.tonFeeFormatted
            }
            
            if item.messages.count == 0 {
                cell.typeImageView.image = R.image.feedHeaderTypeLog()
            }
            
            cell.amountLabel.text = item.amount.tonCurrencySigned
            cell.timeLabel.text = AgoDateFormatter.instance.string(for: item.utime)
            cell.addressLabel.attributedText = item.address.raw.getTonLinkAddress(with: item.address.getWalletName())
        default:
            let message = item.nonEmptyMessages[index - 1]
            
            switch message.type {
            case .in:
                cell.typeImageView.image = R.image.feedMessageTypeOut()
                cell.addressLabel.attributedText = message.source.raw.getTonLinkAddress(with: message.source.getWalletName())
                cell.amountLabel.text = item.nonEmptyMessages.count > 1 ? message.value.tonCurrencySigned : nil
            case .out:
                cell.typeImageView.image = R.image.feedItemMessageTypeIn()
                cell.addressLabel.attributedText = message.destination.raw.getTonLinkAddress(with: message.destination.getWalletName())
                cell.amountLabel.text = item.nonEmptyMessages.count > 1 ? message.value.tonCurrencyNegative : nil
            }
            
            cell.addressLabel.textColor = .white
            cell.feeLabel.text = nil
            cell.timeLabel.text = nil
        }
        
        cell.addressLabel.onClick = { [weak self] label, detection in
            guard case .tag(let tag) = detection.type else { return }
            guard tag.name == "a", let address = tag.attributes["href"] else { return }
            
            let viewController = AddressViewController(address: address)
            
            if let addressViewController = self?.viewController as? AddressViewController, addressViewController.address == address {
                label.shake(on: .x)
                return
            }
            
            self?.viewController?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is FeedItemModel)
        item = object as? FeedItemModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        viewController?.presentPanModal(FeedItemViewController(item: item, selectedIndex: index))
    }
    
}
