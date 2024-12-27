//
//  PersistantCodable.swift
//  Collection
//
//  Created by Dave Coleman on 26/12/2024.
//


//@propertyWrapper
//struct PersistentSet<Element: Codable & RawRepresentable & Hashable & Sendable>: Sendable where Element.RawValue == String {
//  private let key: String
//  private let store: UserDefaults
//
//  var wrappedValue: Set<Element> {
//    get {
//      guard let data = store.data(forKey: key),
//            let decoded = try? JSONDecoder().decode(Set<Element>.self, from: data) else {
//        return []
//      }
//      return decoded
//    }
//    set {
//      guard let encoded = try? JSONEncoder().encode(newValue) else { return }
//      store.set(encoded, forKey: key)
//    }
//  }
//
//  var projectedValue: Self { self }
//
//  mutating func binding(for item: Element) -> Binding<Bool> {
//    Binding(
//      get: { wrappedValue.contains(item) },
//      set: { isVisible in
//        var set = wrappedValue
//        if isVisible {
//          set.insert(item)
//        } else {
//          set.remove(item)
//        }
//        wrappedValue = set
//      }
//    )
//  }
//
//  init(_ key: String, store: UserDefaults = .standard) {
//    self.key = key
//    self.store = store
//  }
//}


//@propertyWrapper
//struct CodableSet<T: Codable & Hashable> {
//  private let key: String
//  private let defaultValue: Set<T>
//
//  init(key: String, defaultValue: Set<T>) {
//    self.key = key
//    self.defaultValue = defaultValue
//  }
//
//  var wrappedValue: Set<T> {
//    get {
//      guard let data = UserDefaults.standard.data(forKey: key),
//            let set = try? JSONDecoder().decode(Set<T>.self, from: data)
//      else { return defaultValue }
//      return set
//    }
//    set {
//      guard let data = try? JSONEncoder().encode(newValue) else { return }
//      UserDefaults.standard.set(data, forKey: key)
//    }
//  }
//}
//
//
//
//class CodableAppStorageObject<T: Codable>: ObservableObject {
//  private let key: String
//  private let defaultValue: T
//  @AppStorage private var data: Data
//  @Published private(set) var value: T
//
//  init(key: String, defaultValue: T) {
//    self.key = key
//    self.defaultValue = defaultValue
//    let encoder = JSONEncoder()
//    let initialData = (try? encoder.encode(defaultValue)) ?? Data()
//    self._data = AppStorage(wrappedValue: initialData, key)
//
//    if let decoded = try? JSONDecoder().decode(T.self, from: initialData) {
//      self.value = decoded
//    } else {
//      self.value = defaultValue
//    }
//  }
//
//  func update(_ newValue: T) {
//    value = newValue
//    do {
//      data = try JSONEncoder().encode(newValue)
//    } catch {
//      print("Error encoding \(newValue): \(error)")
//    }
//  }
//}


//
//@ObservableDefaults()
//final class InfoBarItems {
//
//  var items: [InfoBarItem] = [.pan, .zoom]
//
//  init() {
//
//  }
//}
