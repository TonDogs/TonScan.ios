import Foundation

public struct NSExceptionError: Swift.Error {

    public let exception: NSException

    public init(exception: NSException) {
       self.exception = exception
    }
    
}

public struct ObjC {

    public static func perform(workItem: () -> Void) throws {
        let exception = ExecuteWithObjCExceptionHandling {
            workItem()
        }

        if let exception = exception {
            throw NSExceptionError(exception: exception)
        }
    }
    
}
