//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation


extension NSRegularExpression {
   func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
      return matches(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
   }
   
   func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
      return firstMatch(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
   }
}
