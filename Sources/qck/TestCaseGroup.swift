enum TestCaseGroup: String {
  case configurations
  case specs
  case testCases

  static let all: [TestCaseGroup] = [.specs, .configurations, .testCases]

  init?(baseClass: String) {
    if baseClass == "QuickConfiguration" {
      self = .configurations
    } else if baseClass.hasSuffix("Spec") {
      self = .specs
    } else if baseClass.hasSuffix("TestCase") {
      self = .testCases
    } else {
      return nil
    }
  }

  func description(for classes: [String]) -> String {
    var lines: [String] = []

    if let label = parameterLabel {
      lines.append("\(label): [")
    } else {
      lines.append("[")
    }

    for name in classes {
      switch self {
      case .specs, .configurations:
        lines.append("    \(name).self,")
      case .testCases:
        lines.append("    testCase(\(name).allTests),")
      }
    }

    lines.append("]")

    return lines.joined(separator: "\n")
  }

  var parameterLabel: String? {
    switch self {
    case .configurations, .testCases:
      return rawValue
    case .specs:
      return nil
    }
  }
}
