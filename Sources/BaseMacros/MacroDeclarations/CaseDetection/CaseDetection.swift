// The Swift Programming Language
// https://docs.swift.org/swift-book

/// Add computed properties named `is<Case>` for each case element in the enum.
@attached(member, names: arbitrary)
public macro CaseDetection() =
  #externalMacro(
    module: "UtilityMacros",
    type: "CaseDetectionMacro"
  )
