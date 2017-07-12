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
    "-exec", "sed", "-nE", "s/^.*\(Pattern.testClassDeclaration).*$/\\2 \\1/p", "{}", ";",
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

  let testCases = output.lines
    .sorted()
    .map { line -> (key: TestCaseGroup, value: String) in
      let components = line.split(separator: " ").map { String($0) }
      return (TestCaseGroup(baseClass: components[0])!, components[1])
    }
    .grouped()

  let descriptions: [String] = TestCaseGroup.all.flatMap { group -> String? in
    guard let classes = testCases[group] else { return nil }
    return group.description(for: classes)
  }

  print("import Quick")
  print("import XCTest")
  print()

  if testModules.count > 0 {
    for module in testModules {
      print("@testable import \(module.lastComponent)")
    }
    print()
  }

  print("Quick.QCKMain(", terminator: "")
  let parameters = descriptions.joined(separator: ",\n")
  print(parameters, terminator: "")
  print(")")
}
