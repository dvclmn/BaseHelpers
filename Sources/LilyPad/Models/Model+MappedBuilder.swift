//
//  Model+MappedBuilder.swift
//  LilyPad
//
//  Created by Dave Coleman on 18/6/2025.
//

import Foundation

/// Important:
/// `MappedTouchPointsBuilder` scales a normalised touch
/// from 0-1, to the supplied *size*. It does not handle positioning or
/// centring this size within a viewport.
public struct MappedTouchPointsBuilder {
  public let mappedTouches: Set<TouchPoint>
//  public let mappedTouches: Set<MappedTouchPoint>
  let mappedSize: CGSize
  
  public init(
    touches: Set<TouchPoint>,
    in mappingSize: CGSize
  ) {
    let mapped = Self.mapTouches(touches, mappingSize: mappingSize)
    self.mappedTouches = mapped
    self.mappedSize = mappingSize
  }
  
  public init(
    touches: Set<TouchPoint>,
    mappedTo mappingSize: CGSize
  ) {
    self.init(touches: Set(touches), in: mappingSize)
  }
  
  private static func mapTouches(
    _ touches: Set<TouchPoint>,
    mappingSize: CGSize
  ) -> Set<TouchPoint> {
//  ) -> Set<MappedTouchPoint> {
    let mapped: [TouchPoint] = touches.map { touchPoint in
//    let mapped: [MappedTouchPoint] = touches.map { touchPoint in
      let newPosition = touchPoint.position.mapped(to: mappingSize.toCGRectZeroOrigin)
      
      return TouchPoint(
//      return MappedTouchPoint(
        current: touchPoint,
        updatedPosition: newPosition,
        mappedSize: mappingSize
      )
//      return MappedTouchPoint(
//        id: touchPoint.id,
//        phase: touchPoint.phase,
//        position: newPosition,
//        timestamp: touchPoint.timestamp,
//        velocity: touchPoint.velocity,
//        pressure: touchPoint.pressure,
//        mappedSize: mappingSize
//      )
    }
    return Set(mapped)
  }
  
  public func mappedTouch(withID id: TouchPoint.ID) -> TouchPoint? {
//  public func mappedTouch(withID id: TouchPoint.ID) -> MappedTouchPoint? {
    guard let touch = mappedTouches.first(where: { $0.id == id }) else {
      print("Couldn't find TouchPoint matching id: \(id)")
      return nil
    }
    return touch
  }
  
}
