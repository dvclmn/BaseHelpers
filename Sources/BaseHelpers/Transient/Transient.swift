//
//  Transient.swift
//  Collection
//
//  Created by Dave Coleman on 24/9/2024.
//

//@propertyWrapper
//public struct Transient<T>: Codable {
//  public var wrappedValue: T?
//  
//  public init(wrappedValue: T?) {
//    self.wrappedValue = wrappedValue
//  }
//  
//  public init(from decoder: Decoder) throws {
//    self.wrappedValue = nil
//  }
//  
//  public func encode(to encoder: Encoder) throws {
//    // Do nothing
//  }
//}
//
//extension KeyedDecodingContainer {
//  public func decode<T>(
//    _ type: Transient<T>.Type,
//    forKey key: Self.Key) throws -> Transient<T>
//  {
//    return Transient(wrappedValue: nil)
//  }
//}
//
//extension KeyedEncodingContainer {
//  public mutating func encode<T>(
//    _ value: Transient<T>,
//    forKey key: KeyedEncodingContainer<K>.Key) throws
//  {
//    // Do nothing
//  }
//}
