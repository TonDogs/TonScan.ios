import QuartzCore

extension CALayer {
    
    func pause() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        
        speed = 0.0
        timeOffset = pausedTime
    }

    func resume() {
        let pausedTime = timeOffset
        
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        
        beginTime = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }
    
}
