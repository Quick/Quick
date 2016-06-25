import Foundation

@noreturn internal func raiseError(_ message: String) {
#if _runtime(_ObjC)
    NSException(name: .internalInconsistencyException, reason: message, userInfo: nil).raise()
#endif

    // This won't be reached when ObjC is available and the exception above is raisd
    fatalError(message)
}
