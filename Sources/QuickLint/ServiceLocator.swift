// Not my favorite way of managing dependencies, but it works for
// small projects like QuickLint. This is still significantly better
// than using global singletons, anyway.
//
// This is only used at the top-level `LintCommand` and `DefocusCommand`.
struct ServiceLocator {
    lazy var defocusFormatter: DefocusFormatter = {
        FoundationDefocusFormatter(
            detector: detector,
            fileInterface: fileInterface
        )
    }()

    lazy var detector: FileDetector = {
        return FoundationFileDetector(
            directoryManager: directoryManager,
            fileInterface: fileInterface
        )
    }()

    lazy var directoryManager: DirectoryManager = FoundationDirectoryManager()

    lazy var fileInterface: FileInterface = SimpleFileInterface()

    lazy var linter: FocusLint = {
        return XcodeFocusLint(detector: detector, output: writer)
    }()

    lazy var writer: Writer = TerminalWriter()
}

extension ServiceLocator: Codable {
    init(from decoder: any Decoder) throws {}
    func encode(to encoder: any Encoder) throws {}
}
