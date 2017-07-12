extension String {
  var lines: LazySequence<AnySequence<String>> {
    return AnySequence { () -> AnyIterator<String> in
      var searchRange = self.startIndex..<self.endIndex

      return AnyIterator {
        var nextLine: String?

        self.enumerateSubstrings(in: searchRange, options: .byLines) { line, _, lineRange, stop in
          nextLine = line
          searchRange = lineRange.upperBound..<searchRange.upperBound
          stop = true
        }

        return nextLine
      }
    }.lazy
  }
}
