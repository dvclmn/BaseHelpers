//
//  Pluraliser.swift
//  Collection
//
//  Created by Dave Coleman on 24/9/2024.
//

//let pluralizeWord = { $0 == 1 ? $1 : "\($1)s" }
// Credit: Sparkle swift package
public func pluralise(_ count: Int, _ word: String) -> String {
  if count > 1 {
    return word + "s"
  } else {
    return word
  }
}

