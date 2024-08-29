////
////  TouchInertia.swift
////  Helpers
////
////  Created by Dave Coleman on 25/8/2024.
////
//
//import SwiftUI
//
//class TouchInertia {
//  
//  private var inertiaTimer: Timer?
//  private var inertiaVelocity: CGPoint = .zero
//  private var lastPanLocation: CGPoint?
//  private var lastPanTime: TimeInterval?
//  
//  var lastOffset: CGPoint = .zero
//  
//  
//  private func applyElasticLimit(_ proposedTranslation: CGSize) -> CGSize {
//    let elasticX = elasticValue(proposedTranslation.width, limit: elasticLimit)
//    let elasticY = elasticValue(proposedTranslation.height, limit: elasticLimit)
//    return CGSize(width: elasticX, height: elasticY)
//  }
//  
//  private func elasticValue(_ value: CGFloat, limit: CGFloat) -> CGFloat {
//    if abs(value) <= limit {
//      return value
//    } else {
//      let overflow = abs(value) - limit
//      let direction: CGFloat = value > 0 ? 1 : -1
//      return direction * (limit + log10(overflow + 1) * 20)
//    }
//  }
//  
////  @objc private func handlePan(_ gesture: NSPanGestureRecognizer) {
////    let translation = gesture.translation(in: self)
////    let currentLocation = gesture.location(in: self)
////    let currentTime = CACurrentMediaTime()
////    
////    switch gesture.state {
////      case .began:
////        stopInertia()
////      case .changed:
////        offset = CGPoint(x: offset.x + translation.x, y: offset.y + translation.y)
////        gesture.setTranslation(.zero, in: self)
////        updateContentTransform()
////        
////        if let lastLocation = lastPanLocation, let lastTime = lastPanTime {
////          let dt = CGFloat(currentTime - lastTime)
////          let dx = currentLocation.x - lastLocation.x
////          let dy = currentLocation.y - lastLocation.y
////          inertiaVelocity = CGPoint(x: dx / dt, y: dy / dt)
////        }
////      case .ended:
////        startInertia()
////      default:
////        break
////    }
////    
////    lastPanLocation = currentLocation
////    lastPanTime = currentTime
////  }
//  
//  
//  
////  private func startInertia() {
////    lastTranslation = translation
////    lastScale = scale
////    
////    inertiaTimer?.cancel()
////    inertiaTimer = Timer.publish(every: 1/60, on: .main, in: .common)
////      .autoconnect()
////      .sink { _ in
////        if abs(velocity.width) < 0.1 && abs(velocity.height) < 0.1 {
////          inertiaTimer?.cancel()
////        } else {
////          translation = applyElasticLimit(CGSize(
////            width: translation.width + velocity.width,
////            height: translation.height + velocity.height
////          ))
////          
////          
////          velocity = CGSize(
////            width: velocity.width * inertiaDecay,
////            height: velocity.height * inertiaDecay
////          )
////        }
////      }
////  }
//  
//  // Another attempt?
//  private func startInertia() {
//    inertiaTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] _ in
//      self?.applyInertia()
//    }
//  }
//  
//  private func stopInertia() {
//    inertiaTimer?.invalidate()
//    inertiaTimer = nil
//  }
//  
//  private func applyInertia() {
//    let decelerationRate: CGFloat = 0.95
//    let minVelocity: CGFloat = 0.1
//    
//    offset.x += inertiaVelocity.x
//    offset.y += inertiaVelocity.y
//    
//    inertiaVelocity.x *= decelerationRate
//    inertiaVelocity.y *= decelerationRate
//    
//    if abs(inertiaVelocity.x) < minVelocity && abs(inertiaVelocity.y) < minVelocity {
//      stopInertia()
//    }
//    
//    updateContentTransform()
//  }
//  
//  
//  private func updateContentPosition() {
//    content?.frame.origin = offset
//  }
//}
//
