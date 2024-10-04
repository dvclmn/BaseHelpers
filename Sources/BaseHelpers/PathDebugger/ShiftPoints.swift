//
//  ShiftPoints.swift
//  Collection
//
//  Created by Dave Coleman on 4/10/2024.
//

import SwiftUI

public extension CGPoint {
  // Shift right (increases x)
  func shiftRight(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + distance, y: self.y)
  }
  
  // Shift left (decreases x)
  func shiftLeft(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x - distance, y: self.y)
  }
  
  // Shift down (increases y)
  func shiftDown(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y + distance)
  }
  
  // Shift up (decreases y)
  func shiftUp(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y - distance)
  }
  
  // Shift diagonally
  func shift(dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + dx, y: self.y + dy)
  }
  
  // Shift by another point
  func shift(by point: CGPoint) -> CGPoint {
    return CGPoint(x: self.x + point.x, y: self.y + point.y)
  }
}

// Example usage
//struct ContentView: View {
//  var body: some View {
//    let basePoint = CGPoint(x: 100, y: 100)
//    
//    Path { path in
//      path.move(to: basePoint)
//      path.addLine(to: basePoint.shiftRight(50))
//      path.addLine(to: basePoint.shiftRight(50).shiftDown(50))
//      path.addLine(to: basePoint.shiftDown(50))
//      path.closeSubpath()
//    }
//    .stroke(Color.blue, lineWidth: 2)
//    .frame(width: 200, height: 200)
//  }
//}
