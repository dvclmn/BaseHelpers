//
//  Resizable+UserDefaults.swift
//  Collection
//
//  Created by Dave Coleman on 18/9/2024.
//

import SwiftUI

@propertyWrapper
struct DynamicKeyAppStorage<T: Codable> {
  private let key: String
  private let defaultValue: T
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get {
      let data = UserDefaults.standard.data(forKey: key)
      let value = data.flatMap { try? JSONDecoder().decode(T.self, from: $0) }
      return value ?? defaultValue
    }
    set {
      let data = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(data, forKey: key)
    }
  }
}

