extension Sequence {
  func grouped<Key: Hashable, Value>() -> [Key: [Value]] where Iterator.Element == Dictionary<Key, Value>.Iterator.Element {
    var grouped: [Key: [Value]] = [:]
    for (key, value) in self {
      var values = grouped[key] ?? []
      values.append(value)
      grouped[key] = values
    }
    return grouped
  }
}
