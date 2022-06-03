import QuartzCore

extension CAGradientLayer {
    
    static func getPoints(angle: CGFloat) -> (startPoint: CGPoint, endPoint: CGPoint) {
        let alpha = Float(angle / 360.0)
        let startPointX = powf(sinf(2.0 * Float.pi * ((alpha + 0.75) / 2.0)), 2.0)
        let startPointY = powf(sinf(2.0 * Float.pi * ((alpha + 0) / 2.0)), 2.0)
        let endPointX = powf(sinf(2.0 * Float.pi * ((alpha + 0.25) / 2.0)), 2.0)
        let endPointY = powf(sinf(2.0 * Float.pi * ((alpha + 0.5) / 2.0)), 2.0)
        
        return (CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY)), CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY)))
    }
    
    func setPoints(angle: CGFloat) {
        let points = CAGradientLayer.getPoints(angle: angle)

        endPoint = points.endPoint
        startPoint = points.startPoint
    }
    
}
