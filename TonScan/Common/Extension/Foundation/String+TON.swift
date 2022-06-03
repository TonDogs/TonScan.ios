import Atributika

extension String {
    
    private struct LinkStyle {
        static let instance = Style("a").foregroundColor(R.color.primaryLink()!)
            .foregroundColor(R.color.primaryLink()!.withAlphaComponent(0.6), .highlighted)
    }
    
    var tonLinkAddress: AttributedText {
        "<a href=\"\(self)\">\(tonTruncatedAddress)</a>".style(tags: LinkStyle.instance)
    }
    
    var tonAddress: AttributedText {
        tonTruncatedAddress.style(tags: LinkStyle.instance)
    }
    
    var tonTruncatedAddress: String {
        self.truncated(limit: 12, position: .middle)
    }
    
    func getTonLinkAddress(with name: String) -> AttributedText {
        "<a href=\"\(self)\">\(name)</a>".style(tags: LinkStyle.instance)
    }
    
}
