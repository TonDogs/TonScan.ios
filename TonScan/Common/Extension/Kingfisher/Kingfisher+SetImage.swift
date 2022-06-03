import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    
    @discardableResult
    public func setImage(with source: String?, placeholder: Placeholder? = nil, options: KingfisherOptionsInfo? = nil, progressBlock: DownloadProgressBlock? = nil, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        let url: URL?
        if let source = source {
            url = URL(string: source)
        } else {
            url = nil
        }
        
        return setImage(with: url, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
}

extension KingfisherWrapper where Base: UIButton {
    
    @discardableResult
    public func setImage(with source: String?, for state: UIControl.State, placeholder: UIImage? = nil, options: KingfisherOptionsInfo? = nil, progressBlock: DownloadProgressBlock? = nil, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        let url: URL?
        if let source = source {
            url = URL(string: source)
        } else {
            url = nil
        }
        
        return setImage(with: url, for: state, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
}
