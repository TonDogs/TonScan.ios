import IGListKit
import Kingfisher

class FeedItemDetailsSectionController: ListSectionController {
    
    private let selectedIndex: Int
    private var item: FeedItemModel!
    private let template = FeedItemDetailCell()
    
    init(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        super.init()
        inset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    }
    
    private func isMessage() -> Bool {
        return selectedIndex > 0
    }
    
    override func numberOfItems() -> Int {
        return isMessage() && item.nonEmptyMessages[selectedIndex - 1].message.body != nil ? 4 : 3
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return configure(cell: template, index: index).sizeThatFits(collectionContext!.containerSize.inset(by: inset))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return configure(cell: collectionContext!.dequeue(of: FeedItemDetailCell.self, for: self, at: index), index: index)
    }
    
    private func configure(cell: FeedItemDetailCell, index: Int) -> FeedItemDetailCell {
        let cell = isMessage() ? configureMessage(cell: cell, index: index) : configureTransaction(cell: cell, index: index)
        
        switch index {
        case 0:
            cell.backgroundImageView.image = StretchedImageService.feedHeaderBackground.image
        case numberOfItems() - 1:
            cell.backgroundImageView.image = StretchedImageService.feedFooterBackground.image
        default:
            cell.backgroundImageView.image = StretchedImageService.feedMiddleBackground.image
        }
        
        return cell
    }
    
    private func configureMessage(cell: FeedItemDetailCell, index: Int) -> FeedItemDetailCell {
        let message = item.nonEmptyMessages[selectedIndex - 1]
        
        switch index {
        case 0:
            cell.titleLabel.text = R.string.localizable.itemSource()
            cell.subtitleLabel.text = message.source.raw
        case 1:
            cell.titleLabel.text = R.string.localizable.itemDestination()
            cell.subtitleLabel.text = message.destination.raw
        case 2:
            cell.titleLabel.text = R.string.localizable.itemValue()
            cell.subtitleLabel.text = message.value.tonCurrency
        case 3:
            cell.titleLabel.text = R.string.localizable.itemMessage()
            cell.subtitleLabel.text = message.message.body
        default:
            break
        }
        
        cell.separatorStyle = index < numberOfItems() - 1 ? .insets : .none
        
        return cell
    }
    
    private func configureTransaction(cell: FeedItemDetailCell, index: Int) -> FeedItemDetailCell {
        switch index {
        case 0:
            switch item.type {
            case .in:
                cell.titleLabel.text = R.string.localizable.itemSender()
                cell.subtitleLabel.text = item.sender
            case .out:
                cell.titleLabel.text = R.string.localizable.itemRecipient()
                cell.subtitleLabel.text = item.recipient
            }
        case 1:
            cell.titleLabel.text = R.string.localizable.itemTranscation()
            cell.subtitleLabel.text = item.hash
        case 2:
            cell.titleLabel.text = R.string.localizable.itemFee()
            cell.subtitleLabel.text = item.fee.total.tonFeeFormatted
        default:
            break
        }
        
        cell.separatorStyle = index < numberOfItems() - 1 ? .insets : .none
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is FeedItemModel)
        item = object as? FeedItemModel
    }
    
}
