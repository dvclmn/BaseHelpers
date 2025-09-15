//
//  PrintPadded.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/9/2025.
//

import Foundation

public func printPadded(
  _ message: String,
  withTimestamp: Bool = true
) {
  let adjustedMessage = "\(message)\n\n"
  guard withTimestamp else {
    print(adjustedMessage)
    return
  }
  
  let timestamp: String = Date.now.formatted(.dateTime
    .hour(.twoDigits(amPM: .abbreviated))
    .minute(.twoDigits)
    .second(.twoDigits)
    .secondFraction(.milliseconds(3))
  )
  print("(\(timestamp)) " + adjustedMessage)
}
