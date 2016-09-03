/**
 A description of the execution cycle of the current example with
 respect to the hooks of that example.
 */
internal enum HooksPhase: Int {
    case nothingExecuted = 0
    case beforesExecuting
    case beforesFinished
    case aftersExecuting
    case aftersFinished
}
