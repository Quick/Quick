import Foundation

extension String {

    var fileName: String? {
        return NSURL(string: self)?.URLByDeletingPathExtension?.lastPathComponent
    }

}
