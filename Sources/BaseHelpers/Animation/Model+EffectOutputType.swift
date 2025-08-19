//
//  Model+EffectOutputType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/8/2025.
//

import SwiftUI

public enum EffectOutputKind: String, CaseIterable, Identifiable {
  case scalar
  case size
  case angle

  public var id: String { rawValue }
}

//public enum AnyEffectOutput: Equatable, Hashable {
//  case scalar(CGFloat = .zero)
//  case size(CGSize = .zero)
//  case angle(Angle = .zero)
//
//  public static func create(fromAny value: Any) -> Self {
//    if let result = value as? CGFloat {
//      return Self.create(fromScalar: result)
//    } else if let result = value as? CGSize {
//      return Self.create(fromSize: result)
//    } else if let result = value as? Angle {
//      return Self.create(fromAngle: result)
//    } else {
//      fatalError("Unsupported type for EffectOutput")
//    }
//  }
//
//  public static func create(fromScalar value: CGFloat) -> Self {
//    return .scalar(value)
//  }
//  public static func create(fromSize value: CGSize) -> Self {
//    return .size(value)
//  }
//  public static func create(fromAngle value: Angle) -> Self {
//    return .angle(value)
//  }
//
//  public var scalar: CGFloat {
//    guard let result = self.value as? CGFloat else {
//      fatalError("Cannot obtain a scalar value from non-scalar EffectOutput")
//    }
//    return result
//  }
//  public var size: CGSize {
//    guard let result = self.value as? CGSize else {
//      fatalError("Cannot obtain a size value from non-size EffectOutput")
//    }
//    return result
//  }
//  public var angle: Angle {
//    guard let result = self.value as? Angle else {
//      fatalError("Cannot obtain a angle value from non-angle EffectOutput")
//    }
//    return result
//  }
//
//  public var outputKind: EffectOutputKind {
//    switch self {
//      case .scalar: .scalar
//      case .size: .size
//      case .angle: .angle
//    }
//  }
//
//  public var value: Any {
//    switch self {
//      case .scalar(let output): output
//      case .size(let output): output
//      case .angle(let output): output
//    }
//  }
//
//  //  public var type: Any.Type {
//  //    switch self {
//  //      case .scalar: CGFloat.self
//  //      case .size: CGSize.self
//  //      case .angle: Angle.self
//  //    }
//  //  }
//
//  //  public var effectKinds: [EffectKind] {
//  //    switch self {
//  //      case .scalar: [.blur]
//  //      case .size: [.offset, .scale]
//  //      case .angle: []
//  //    }
//  //  }
//}
