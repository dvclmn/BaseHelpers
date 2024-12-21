//
//  CGRect.swift
//  Collection
//
//  Created by Dave Coleman on 9/12/2024.
//

import SwiftUI

public extension CGRect {
  var path: Path {
    Path(self)
  }
  
  
  func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    
    let width: String = "\(self.width.toDecimal(decimalPlaces))"
    let height: String = "\(self.height.toDecimal(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .initials:
        return "W \(width)  H \(height)"
        
      case .full:
        return "Width \(width)  Height \(height)"
    }
  }
}

