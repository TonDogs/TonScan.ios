import Foundation

class DispatchTimer {

    private let queue: DispatchQueue
    private let timeInterval: TimeInterval
    private let block: (() -> Void)

    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now() + timeInterval, repeating: timeInterval)
        
        timer.setEventHandler { [weak self] in
            guard let self = self else {
                return
            }

            self.block()
        }

        return timer
    }()

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    init(queue: DispatchQueue, timeInterval: TimeInterval, block: @escaping(() -> Void)) {
        self.queue = queue
        self.timeInterval = timeInterval
        self.block = block
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
    }

    func resume() {
        if state == .resumed {
            return
        }

        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }

        state = .suspended
        timer.suspend()
    }
}
