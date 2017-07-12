import PathKit

private enum Pattern {
  static let space = "[[:space:]]"
  static let identifier = "[[:alnum:]_]+"
  static let className = "class\(space)+(\(identifier))"
  static let baseClass = "(\(identifier)(Configuration|Spec|TestCase))"
  static let testClassDeclaration = "\(className)\(space)*:\(space)*\(baseClass)"
}

func generateMain() throws {
  let testRoot = try packageRoot() + "Tests"

  let io = try popen([
    "find",
    testRoot.string,
    "-name", "*.swift",
    "-exec", "sed", "-nE", "s/^.*\(Pattern.testClassDeclaration).*$/\\1/p", "{}", ";",
  ])

  let data = io.output.readDataToEndOfFile()

  guard io.process.terminationStatus == 0 else {
    throw QckError.internalError
  }

  guard let output = String(data: data, encoding: .utf8) else {
    throw QckError.badEncoding(expected: .utf8)
  }

  let testModules = try testRoot.children().filter { path in
    path.isDirectory && path.lastComponent.hasSuffix("Tests")
  }

  print("import Quick")
  print()

  if testModules.count > 0 {
    for module in testModules {
      print("@testable import \(module.lastComponent)")
    }
    print()
  }

  print("QCKMain([")
  for spec in output.lines.sorted() {
    print("  \(spec).self,")
  }
  print("])")
}
