//
//  AnyWrapper.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/5/2025.
//

/// 1. Define a protocol for the ID
protocol ErasedID: Codable, Hashable, Equatable, Sendable {
  associatedtype Service: SomeService
  var id: Int { get }
}

protocol SomeService {
  associatedtype Authenticator: Authenticatable
  
  var serviceType: GameServiceType { get }
  var auth: Authenticator { get }
  
}

/// 2. Define the type-erased wrapper
struct AnyErasedID: Hashable, Codable {
  private let _id: Int
  private let _type: ObjectIdentifier
  private let _box: BoxBase
  
  private class BoxBase: @unchecked Sendable, Codable, Hashable {
    static func == (lhs: BoxBase, rhs: BoxBase) -> Bool {
      fatalError("Implement in subclass")
    }
    
    func hash(into hasher: inout Hasher) {
      fatalError("Implement in subclass")
    }
  }
  
  private final class Box<T: ErasedID>: BoxBase {
    let wrapped: T
    
    init(_ wrapped: T) {
      self.wrapped = wrapped
    }
    
    override func hash(into hasher: inout Hasher) {
      wrapped.hash(into: &hasher)
    }
    
    override class func == (lhs: BoxBase, rhs: BoxBase) -> Bool {
      guard let lhs = lhs as? Box<T>, let rhs = rhs as? Box<T> else { return false }
      return lhs.wrapped == rhs.wrapped
    }
  }
  
  init<T: ErasedID>(_ concrete: T) {
    self._id = concrete.id
    self._type = ObjectIdentifier(T.Service.self)
    self._box = Box(concrete)
  }
  
  func cast<T: ErasedID>(to type: T.Type) -> T? {
    (_box as? Box<T>)?.wrapped
  }
}
