//
//  BackupDisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import SwiftUI

extension CGPoint {
  public var displayString: String {
    self.displayString(style: .long)
  }
  
  public func displayString(decimalPlaces: Int = 2) -> String {
    return "\(self.x.displayString(decimalPlaces)) x \(self.y.displayString(decimalPlaces))"
  }
  
  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {
    
    let width: String = "\(self.x.displayString(decimalPlaces))"
    let height: String = "\(self.y.displayString(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .long, .standard:
        return "X \(width)  Y \(height)"
        
    }
  }
  

}

extension CGSize {
  public var displayString: String {
    displayString()
  }
  
  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    
    let width: String = "\(self.width.displayString(decimalPlaces))"
    let height: String = "\(self.height.displayString(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .standard:
        return "W \(width)  H \(height)"
        
      case .long:
        return "Width \(width)  Height \(height)"
    }
  }
  
//  @available(*, deprecated, message: "This function is deprecated. Use `displayString` instead")
//  public var asString: String {
//    "Width: \(width.padLeading(maxDigits: 3, decimalPlaces: 2)) x Height: \(height.padLeading(maxDigits: 3, decimalPlaces: 2))"
//  }

}

extension CGVector {
  public var displayString: String {
    self.displayString(style: .long)
  }
  
  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {
    
    let dxString = "\(self.dx.displayString(decimalPlaces))"
    let dyString = "\(self.dy.displayString(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(dxString) x \(dyString)"
        
      case .long, .standard:
        return "dx: \(dxString)  dy: \(dyString)"
        
        
    }
  }

}

extension UnitPoint {
  public var displayString: String {
    self.displayString(style: .long)
  }
  
  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {
    
    let width: String = "\(self.x.displayString(decimalPlaces))"
    let height: String = "\(self.y.displayString(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .long, .standard:
        return "X \(width)  Y \(height)"
        
    }
  }

}

extension CGRect {
  public var displayString: String {
    self.displayString()
  }
  
  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    
    let originX: String = "\(self.origin.x.displayString(decimalPlaces))"
    let originY: String = "\(self.origin.y.displayString(decimalPlaces))"
    let width: String = "\(self.width.displayString(decimalPlaces))"
    let height: String = "\(self.height.displayString(decimalPlaces))"
    
    switch style {
      case .short, .standard:
        return "X \(originX), Y \(originY), W \(width), H \(height)"
        
      case .long:
        return "X \(originX), Y \(originY), Width \(width), Height \(height)"
    }
  }
  

}
