# IndexPathChanges.swift

This is a simple Swift function that calculates the difference between two arrays of a collection in a format suitable for doing table view and collection view animations in iOS.  It only supports changes within one section. 

## Usage

Drop the file IndexPathChanges.swift into your project. Use it like this:

```swift
let section = 5
let changes = IndexPathChanges(from: ["A", "C"],
                               to: ["A", "B", "C"],
                               in: section)
```

This works for all types that conform to the `Equatable` protocol. For other types, or if you need specific logic for what it means for two elements to be considered the same, you may give it an `equals` function:

```swift
    let changes = IndexPathChanges(from: ["a", "b"], 
                                   to: ["A", "B"], 
                                   in: section, 
                                   using: {
        $0.caseInsensitiveCompare($1) == ComparisonResult.orderedSame
    })
```

This gives you an `IndexPathChanges` struct with the changes to perform. Provided are also extensions to `UITableView`:

```swift
myTableView.performBatchUpdates(for: changes, with: UITableViewRowAnimation.fade)
```

And `UICollectionView`:

```
myCollectionView.performBatchUpdates(for: changes) { completed in
	print("done")
}
```
## Terms of Use

Public Domain, use in any way you like without need for attribution.
