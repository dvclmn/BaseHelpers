//
//  Dimensions.swift
//  BoxCore
//
//  Created by Dave Coleman on 15/9/2024.
//

public extension BoxCore {
  
  protocol FixedDimension {
    var value: Int { get }
  }
  
  struct Dimensions {
    var width: DimensionType
    var height: DimensionType
    
    init(_ width: DimensionType, _ height: DimensionType) {
      self.width = width
      self.height = height
    }
    
    init(_ width: Int, _ height: Int) {
      self.width = .fixed(.init(width))
      self.height = .fixed(.init(height))
    }
    
  }

  enum DimensionType {
    case fixed(Int)
    case repeatable(min: Int, max: Int?)
    
    var fixedValue: Int? {
      switch self {
        case .fixed(let value):
          return value
        case .repeatable:
          return nil
      }
    }
  }
}

extension BoxCore.DimensionType: BoxCore.FixedDimension {
  
  /// Warning: This will cause a fatal error if accessed for a
  /// variable-width (aka `repeatable`) dimension type.
  ///
  public var value: Int {
    switch self {
      case .fixed(let value):
        return value
      case .repeatable:
        fatalError("Cannot get fixed value from a repeatable dimension")
    }
  }
}
