# Regex

## Matches
Reminder: The first `Substring` is always the whole match,
then subsequent are those specifically defined/named.

Example of linking to the docs: [`Regex.RegexOutput`](https://developer.apple.com/documentation/swift/regex/regexoutput)

I've noted down the part I usually use
```swift
public struct Regex<Output> : RegexComponent {

  /// The regular expression represented by this component.
  public var regex: Regex<Output> { get }

  /// The output type for this regular expression.
  ///
  /// A `Regex` instance's output type depends on whether the `Regex` has
  /// captures and how it is created.
  /// [...]
  /// - A `Regex` with captures created from a regex literal or the
  ///   ``init(_:as:)`` initializer has a tuple of substrings as its output
  ///   type. The first component of the tuple is the full portion of the string
  ///   that was matched, with the remaining components holding the captures.
  public typealias RegexOutput = Output
}
```
