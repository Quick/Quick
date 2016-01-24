/**
 A description of the execution cycle of the current example with
 respect to the hooks of that example.
 */
internal enum HooksPhase: Int {
    case NothingExecuted = 0
    case BeforesExecuting
    case BeforesFinished
    case AftersExecuting
    case AftersFinished
}
