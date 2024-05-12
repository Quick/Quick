import Foundation

protocol Writer: Sendable {
    func stderr(lines: [String])
}

struct TerminalWriter: Writer {
    func stderr(lines: [String]) {
        guard lines.isEmpty == false else { return }
        let data = Data(lines.joined(separator: newline).appending(newline).utf8)
        FileHandle.standardError.write(data)
    }

    private var newline: String {
        #if os(Windows)
        return "\r\n"
        #else
        return "\n"
        #endif
    }
}
