import Foundation

func popen(_ command: [String]) throws -> (process: Process, output: FileHandle) {
  precondition(command.count > 0, "invalid command")
  var arguments = command
  var path = arguments.removeFirst()

  if !path.contains("/") {
    guard let found = executable(named: path) else { throw QckError.commandNotFound(path) }
    path = found.string
  }

  let output = Pipe()
  let process = Process()
  process.launchPath = path
  process.arguments = arguments
  process.standardOutput = output

  process.launch()

  return (process, output.fileHandleForReading)
}
