# Result Builders

I have starting getting my head around Swift result builders, and getting excited about their potential uses.

Links:
- https://docs.swift.org/compiler/documentation/diagnostics/result-builder-methods/
- 

The most fundamental part of a result builder:
```swift
static func buildBlock(_ components: Component...) -> Component { ... }
```

## `buildBlock`
`buildBlock` stitches multiple expressions together (... arguments).

## `buildExpression`
This one seems important too, but interestingly it doesn't *have* to be part of a builder.

`buildExpression`s answer the question “How do I turn this thing into something that fits in your building pipeline?”.


