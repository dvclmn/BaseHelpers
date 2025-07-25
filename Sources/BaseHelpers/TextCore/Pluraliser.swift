//
//  Pluraliser.swift
//  Collection
//
//  Created by Dave Coleman on 24/9/2024.
//

//let pluralizeWord = { $0 == 1 ? $1 : "\($1)s" }
// Credit: Sparkle swift package

import Foundation

public enum CountStrategy {
  case showCount(shouldDisplayForSingle: Bool = false)
  case hideCount

}


public func pluralise(
  verb: String,
  count: Int,
  noun: String,
  countStrategy: CountStrategy = .hideCount,
  showEllipsis: Bool = false
) -> String {
  
  let result = verb + " " + pluralise(noun, count: count, countStrategy: countStrategy)
  
  return showEllipsis ? result + "..." : result
}


public func pluralise(
  _ word: String,
  count: Int,
  countStrategy: CountStrategy = .hideCount
) -> String {
  
  switch countStrategy {
    case .showCount(let shouldDisplayForSingle):
      if count == 1 {
        return shouldDisplayForSingle ? "\(count.toString) \(word)" : word
      } else {
        return "\(count.toString) \(word)" + "s"
      }
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

