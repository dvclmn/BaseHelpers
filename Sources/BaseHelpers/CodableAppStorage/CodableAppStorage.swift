//
//  CodableAppStorage.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/3/2025.
//

//import SwiftUI

/// I think this has now been deprecated by... other stuff?
//@propertyWrapper
//public struct CodableAppStorage<T>: Sendable, DynamicProperty where T: Codable & Sendable {
//  @State private var value: T
//  private let key: String
//  private let defaultValue: T
//  
//  public init(wrappedValue: T, _ key: String) {
//    self.defaultValue = wrappedValue
//    self.key = key
//    self._value = State(initialValue: {
//      guard let data = UserDefaults.standard.data(forKey: key) else {
//        return wrappedValue
//      }
//      
//      do {
//        return try JSONDecoder().decode(T.self, from: data)
//      } catch {
//        print("Error decoding \(key): \(error)")
//        return wrappedValue
//      }
//    }())
//  }
//  
//  public var wrappedValue: T {
//    get { value }
//    nonmutating set {
//      value = newValue
//      do {
//        let data = try JSONEncoder().encode(newValue)
//        UserDefaults.standard.set(data, forKey: key)
//      } catch {
//        print("Error encoding \(key): \(error)")
//      }
//    }
//  }
//  
//  public var projectedValue: Binding<T> {
//    Binding(
//      get: { wrappedValue },
//      set: { wrappedValue = $0 }
//    )
//  }
//}
