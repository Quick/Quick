import Cpaths
import Foundation
import PathKit

func executable(named name: String) -> Path? {
  let path = ProcessInfo.processInfo.environment["PATH"] ?? _PATH_DEFPATH
  let components = path.split(separator: ":").lazy.map { String($0) }
  let candidates = components.map { Path($0) + "find" }
  return candidates.first { $0.isExecutable }?.normalize()
}
