struct QckError: Error {
  let message: String
}

extension QckError: CustomStringConvertible {
  var description: String {
    return message
  }
}

extension QckError {
  static func badEncoding(expected encoding: String.Encoding) -> QckError {
    return QckError(message: "Bad encoding: expected \(encoding)")
  }

  static func commandNotFound(_ name: String) -> QckError {
    return QckError(message: "\(name): Command not found.")
  }

  static let notAPackage = QckError(message: "The current directory is not a Swift package.")
}
