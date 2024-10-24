//
//  Pluraliser.swift
//  Collection
//
//  Created by Dave Coleman on 24/9/2024.
//

//let pluralizeWord = { $0 == 1 ? $1 : "\($1)s" }
// Credit: Sparkle swift package
public func pluralise(
  _ count: Int,
  _ word: String,
  includeCount: Bool = false
) -> String {
  
  let wordResult: String = includeCount ? "\(count.string) " + word : word
  
  if count == 1 {
    
    return wordResult
    
  } else {
    
    return wordResult + "s"
  }
}

