//
//  TimeInterval.swift
//  Collection
//
//  Created by Dave Coleman on 12/1/2025.
//

import Foundation

public extension TimeInterval {
  init(hours: Double) {
    self.init(hours * 3600) // Convert hours to seconds
  }
  
  init(minutes: Double) {
    self.init(minutes * 60) // Convert minutes to seconds
  }
}
