//
//  AnyWrapper.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/5/2025.
//

/// ```
/// protocol GameServiceID: Hashable, Codable {
///   associatedtype Service: GameService
///   var id: Int { get }
///   static var serviceType: GameServiceType { get }
/// }
/// ```


/// ```
/// enum GameServiceType {
///   case steam
///   case gog
///   case epic
///   // etc.
///
///   func wrap(id: Int) -> AnyGameID {
///     switch self {
///       case .steam: return AnyGameID(SteamAppID(id: id))
///       case .gog: return AnyGameID(GOGAppID(id: id))
///         ...
///     }
///   }
/// }
/// ```
/// Example: `let steamID = GameServiceType.steam.wrap(id: 123)`

/// ```
/// enum GameServiceType {
///   var makeID: ((Int) -> AnyGameID)? {
///     switch self {
///       case .steam: return { AnyGameID(SteamAppID(id: $0)) }
///       case .gog: return { AnyGameID(GOGAppID(id: $0)) }
///         ...
///     }
///   }
/// }
/// // Example:
/// if let id = serviceType.makeID?(123) {
///   // Got an AnyGameID
/// }
/// ```

/// ```
/// // Make GameServiceType not an enum but a struct with internal static registry of builders:
/// struct GameServiceType: Hashable {
///   let id: String
///   let makeID: (Int) -> AnyGameID
///
///   private static var registry: [String: GameServiceType] = [:]
///
///   static func register(id: String, makeID: @escaping (Int) -> AnyGameID) {
///     registry[id] = GameServiceType(id: id, makeID: makeID)
///   }
///
///   static func from(id: String) -> GameServiceType? {
///     registry[id]
///   }
/// }
///
/// // Then during app init or module load:
/// GameServiceType.register(id: "steam") { AnyGameID(SteamAppID(id: $0)) }
/// ```


/// 1. Define a protocol for the ID
//protocol ErasedID: Codable, Hashable, Equatable, Sendable {
//  associatedtype Service: SomeService
//  var id: Int { get }
//}
//
//protocol SomeService {
////  associatedtype Authenticator: Authenticatable
//  
//  var serviceType: GameServiceType { get }
//  var auth: Authenticator { get }
//  
//}
//
///// 2. Define the type-erased wrapper
//struct AnyErasedID: Hashable, Codable {
//  private let _id: Int
//  private let _type: ObjectIdentifier
//  private let _box: BoxBase
//  
//  private class BoxBase: @unchecked Sendable, Codable, Hashable {
//    static func == (lhs: BoxBase, rhs: BoxBase) -> Bool {
//      fatalError("Implement in subclass")
//    }
//    
//    func hash(into hasher: inout Hasher) {
//      fatalError("Implement in subclass")
//    }
//  }
//  
//  private final class Box<T: ErasedID>: BoxBase {
//    let wrapped: T
//    
//    init(_ wrapped: T) {
//      self.wrapped = wrapped
//    }
//    
//    override func hash(into hasher: inout Hasher) {
//      wrapped.hash(into: &hasher)
//    }
//    
//    override class func == (lhs: BoxBase, rhs: BoxBase) -> Bool {
//      guard let lhs = lhs as? Box<T>, let rhs = rhs as? Box<T> else { return false }
//      return lhs.wrapped == rhs.wrapped
//    }
//  }
//  
//  init<T: ErasedID>(_ concrete: T) {
//    self._id = concrete.id
//    self._type = ObjectIdentifier(T.Service.self)
//    self._box = Box(concrete)
//  }
//  
//  func cast<T: ErasedID>(to type: T.Type) -> T? {
//    (_box as? Box<T>)?.wrapped
//  }
//}
