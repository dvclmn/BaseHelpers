//
//  FloatPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

/// I think `FloatPair` can be distinct from `ValuePair`


/// This is for helping unify some operations that benefit
/// both `CGPoint` and `CGSize`. This protocol does
/// care about axis; x/y, horizontal/vertical etc
//public protocol FloatPair {
//  /// For `CGPoint` this is `x`. For `CGSize` this is `width`
//  var valueA: CGFloat { get }
//  
//  /// For `CGPoint` this is `y`. For `CGSize` this is `height`
//  var valueB: CGFloat { get }
//}
//
//extension CGPoint: ValuePair {
//  public var valueA: CGFloat { x }
//  public var valueB: CGFloat { y }
//}
//extension CGSize: ValuePair {
//  public var valueA: CGFloat { width }
//  public var valueB: CGFloat { height }
//}

