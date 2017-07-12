import PathKit

func packageRoot(relativeTo path: Path = .current) throws -> Path {
  var path = path
  var found: Path?

  repeat {
    let isPackageDirectory = try path.children().contains { $0.lastComponent == "Package.swift" }

    if isPackageDirectory {
      found = path
      break
    }

    path = path.parent()
  } while path != "/"

  guard let root = found else { throw QckError.notAPackage }

  return root
}
