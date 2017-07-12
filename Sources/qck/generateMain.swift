import PathKit

func generateMain() throws {
  let testRoot = try packageRoot() + "Tests"

  let io = try popen([
    "find",
    testRoot.string,
    "-name", "*.swift",
    "-exec", "sed", "-nE", "s/^.*class[[:space:]]+([[:alnum:]_]+(Spec|Tests))[[:>:]].*/\\1/p", "{}", ";",
  ])

  let data = io.output.readDataToEndOfFile()
  guard let output = String(data: data, encoding: .utf8) else {
    throw QckError.badEncoding(expected: .utf8)
  }

  print("import Quick")
  print()
  print("QCKMain([")
  for spec in output.lines.sorted() {
    print("  \(spec).self,")
  }
  print("])")
}
