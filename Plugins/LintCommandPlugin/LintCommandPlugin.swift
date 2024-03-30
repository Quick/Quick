import Foundation
import PackagePlugin

@main
struct LintCommandPlugin: CommandPlugin {
    func performCommand(
        context: PluginContext,
        arguments: [String]
    ) throws {
        try run(
            tool: try context.tool(named: "QuickLint"),
            workingDirectory: URL(fileURLWithPath: context.package.directory.string),
            arguments: arguments
        )
    }

    private func run(
        tool: PluginContext.Tool,
        workingDirectory: URL,
        arguments: [String]
    ) throws {
        let process: Process = .init()
        process.currentDirectoryURL = workingDirectory
        process.executableURL = URL(fileURLWithPath: tool.path.string)
        process.arguments = ["lint"] + arguments
        try process.run()
        process.waitUntilExit()
        switch process.terminationReason {
        case .exit:
            break
        case .uncaughtSignal:
            Diagnostics.error("Uncaught Signal")
        @unknown default:
            Diagnostics.error("Unexpected Termination Reason")
        }
        guard process.terminationStatus == EXIT_SUCCESS else {
            Diagnostics.error("Command Failed")
            return
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LintCommandPlugin: XcodeCommandPlugin {
    /// This entry point is called when operating on an Xcode project.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try run(
            tool: context.tool(named: "QuickLint"),
            workingDirectory: URL(fileURLWithPath: context.pluginWorkDirectory.string),
            arguments: []
        )
    }
}
#endif

