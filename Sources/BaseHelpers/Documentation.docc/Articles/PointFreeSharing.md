# Notes on `@Shared` 
A library for persistence and data sharing, by Point-Free

## Overview

I often find myself forgetting the syntax for creating convenient static properties for Point-Free's library [`swift-sharing`](https://github.com/pointfreeco/swift-sharing).

```swift
extension SharedKey where Self == FileStorageKey<ExampleType>.Default {
  static var example: Self {
    Self[
      .fileStorage(
        .applicationSupportDirectory.appending(component: "example.json")
      ),
      default: ExampleType()
    ]
  }
}

extension SharedKey where Self == AppStorageKey<Optional<ExampleType>>.Default {
  static var steamAccount: Self {
    Self[
      .appStorage("exampleStorageKey"),
      default: nil
    ]
  }
}

```


