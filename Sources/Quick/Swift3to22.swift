import Foundation

#if !swift(>=3)
    extension Array {
        mutating func append<C : CollectionType where C.Generator.Element == Element>(contentsOf newElements: C) {
            appendContentsOf(newElements)
        }
    }

    extension CollectionType where Generator.Element : Equatable {
        internal func split(maxSplits maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, @noescape isSeparator: (Generator.Element) throws -> Bool) rethrows -> [SubSequence] {
            return try split(maxSplits, allowEmptySlices: !omittingEmptySubsequences, isSeparator: isSeparator)
        }

        internal func split(separator separator: Self.Generator.Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Self.SubSequence] {
            return split(separator, maxSplit: maxSplits, allowEmptySlices: !omittingEmptySubsequences)
        }
    }
    
    extension CollectionType where Index : RandomAccessIndexType {
        internal func reversed() -> ReverseRandomAccessCollection<Self> {
            return reverse()
        }
    }

    extension MutableCollectionType {
        public func sorted(@noescape isOrderedBefore isOrderedBefore: (Self.Generator.Element, Self.Generator.Element) -> Bool) -> [Self.Generator.Element] {
            return sort(isOrderedBefore)
        }
    }


#endif

#if !swift(>=3) || os(Linux)
    extension NSURL {
        internal var deletingPathExtension: NSURL? {
            return URLByDeletingPathExtension
        }
    }
#endif