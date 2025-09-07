//
//  Pluraliser.swift
//  Collection
//
//  Created by Dave Coleman on 24/9/2024.
//


import Foundation


/// Credit: Sparkle swift package
/// Some logic I found in Sparkle:
/// `let pluralizeWord = { $0 == 1 ? $1 : "\($1)s" }`

public enum CountStrategy {
  case showCount(always: Bool = false) // always: show "1 Game" vs "Game"
  case hideCount
}

//public enum CountStrategy {
//  case showCount(
//    /// always: show "1 Game" vs "Game"
//    shouldDisplayForSingle: Bool = false
//  )
//  case hideCount
//}

public func pluralise(
  _ noun: String,
//  verb: String,
  count: Int,
  countStrategy: CountStrategy = .hideCount,
  irregularPlural: String? = nil
//  showEllipsis: Bool = false
) -> String {
  
  let pluralForm = irregularPlural ?? noun + "s"
  switch countStrategy {
    case .showCount(let always):
      if count == 1 {
        return always ? "1 \(noun)" : noun
      } else {
        return "\(count) \(pluralForm)"
      }
    case .hideCount:
      return count == 1 ? noun : pluralForm
  }
//
//  let result = verb + " " + pluralise(noun, count: count, countStrategy: countStrategy)
//
//  return showEllipsis ? result + "..." : result
}

public func pluralise(
  _ word: String,
  count: Int,
  countStrategy: CountStrategy = .hideCount
) -> String {

  switch countStrategy {
    case .showCount(let shouldDisplayForSingle):
      guard count == 1 else {
        return "\(count.toString) \(word)" + "s"
      }
      return shouldDisplayForSingle ? "\(count.toString) \(word)" : word
    case .hideCount:
      return count == 1 ? word : word + "s"
  }

  //  let wordResult: String = includeCount ? "\(count.string) " + word : word
  //
  //  if count == 1 {
  //
  //    return wordResult
  //
  //  } else {
  //
  //    return wordResult + "s"
  //  }
}

//@available(*, deprecated, message: "Use pluralise(count:word:countStrategy) instead")
//public func pluralise(
//  _ count: Int,
//  _ word: String,
//  includeCount: Bool
//) -> String {
//
//  let wordResult: String = includeCount ? "\(count.toString) " + word : word
//
//  if count == 1 {
//
//    return wordResult
//
//  } else {
//
//    return wordResult + "s"
//  }
//}
