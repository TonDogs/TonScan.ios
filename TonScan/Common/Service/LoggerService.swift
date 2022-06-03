import SwiftyBeaver

let log = SwiftyBeaver.self

struct LoggerService {
    
    static func setup() {
        #if DEBUG
            let consoleDestination = ConsoleDestination()
            log.addDestination(consoleDestination)
        #endif

        let fileDestination = FileDestination()
        log.addDestination(fileDestination)
    }
    
}
