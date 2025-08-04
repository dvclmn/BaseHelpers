//
//  CGSizeOperators.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/7/2025.
//

import Foundation

// MARK: - Subtraction
//infix operator - : AdditionPrecedence

public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
  return CGSize(
    width: lhs.width - rhs.width,
    height: lhs.height - rhs.height
  )
}
public func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(
    width: lhs.width - rhs,
    height: lhs.height - rhs
  )
}
public func - (lhs: CGSize, rhs: CGPoint) -> CGSize {
  return CGSize(
    width: lhs.width - rhs.x,
    height: lhs.height - rhs.y
  )
}

// MARK: - Addition
public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
  return CGSize(
    width: lhs.width + rhs.width,
    height: lhs.height + rhs.height
  )
}
public func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(
    width: lhs.width + rhs,
    height: lhs.height + rhs
  )
}

public func + (lhs: CGFloat, rhs: CGSize) -> CGSize {
  return CGSize(
    width: lhs + rhs.width,
    height: lhs + rhs.height
  )
}

public func += (lhs: inout CGSize, rhs: CGFloat) {
  lhs = lhs + rhs
}
public func += (lhs: inout CGSize, rhs: CGSize) {
  lhs.width += rhs.width
  lhs.height += rhs.height
}

// MARK: - Multiplication
//infix operator * : MultiplicationPrecedence

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(
    width: lhs.width * rhs,
    height: lhs.height * rhs
  )
}

// MARK: - Division
public func / (lhs: CGSize, rhs: CGSize) -> CGSize {
  precondition(rhs.width != 0 && rhs.height != 0, "Cannot divide by zero size")
  return CGSize(
    width: lhs.width / rhs.width,
    height: lhs.height / rhs.height
  )
}

public func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
  precondition(rhs != 0 && rhs != 0, "Cannot divide by zero size")
  return CGSize(
    width: lhs.width / rhs,
    height: lhs.height / rhs
  )
}

//public func positiveScale(_ size: CGSize, by factor: CGFloat) -> CGSize {
//  let result = size * factor
//  precondition(result.width > 0 && result.height > 0, "Scaling resulted in non-positive size")
//  return result
//}

//public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
//  let result = CGSize(
//    width: lhs.width * rhs,
//    height: lhs.height * rhs
//  )
//  precondition(result.width > 0 && result.height > 0, "Cannot have a size with width or height less than or equal to zero")
//  return result
//
//}

// MARK: - Greater than
//infix operator > : ComparisonPrecedence

//public func > (lhs: CGSize, rhs: CGFloat) -> Bool {
//  lhs.width > rhs || lhs.height > rhs
//}
//
//public func > (lhs: CGSize, rhs: CGSize) -> Bool {
//  lhs.width > rhs.width || lhs.height > rhs.height
//}

// MARK: - Less than
//infix operator < : ComparisonPrecedence

//public func < (lhs: CGSize, rhs: CGFloat) -> Bool {
//  lhs.width < rhs || lhs.height < rhs
//}

//infix operator >= : ComparisonPrecedence
/// Returns true if both width and height are greater than or equal to the compared size
//public func >= (lhs: CGSize, rhs: CGSize) -> Bool {
//  return lhs.width >= rhs.width && lhs.height >= rhs.height
//}
