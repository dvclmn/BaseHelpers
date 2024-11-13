//
//  Encrypt.swift
//  Collection
//
//  Created by Dave Coleman on 2/10/2024.
//

import Foundation
import CryptoKit

class SimpleEncryption {
  static let shared = SimpleEncryption()
  
  private let key: SymmetricKey
  
  private init() {
    // Generate a random key or retrieve an existing one
    if let savedKey = UserDefaults.standard.data(forKey: "simpleEncryptionKey") {
      self.key = SymmetricKey(data: savedKey)
    } else {
      self.key = SymmetricKey(size: .bits256)
      UserDefaults.standard.set(key.withUnsafeBytes { Data($0) }, forKey: "simpleEncryptionKey")
    }
  }
  
  func encrypt(_ string: String) -> String? {
    guard let data = string.data(using: .utf8) else { return nil }
    do {
      let encrypted = try AES.GCM.seal(data, using: key)
      return encrypted.combined?.base64EncodedString()
    } catch {
      print("Encryption error: \(error)")
      return nil
    }
  }
  
  func decrypt(_ string: String) -> String? {
    guard let data = Data(base64Encoded: string) else { return nil }
    do {
      let sealedBox = try AES.GCM.SealedBox(combined: data)
      let decrypted = try AES.GCM.open(sealedBox, using: key)
      return String(data: decrypted, encoding: .utf8)
    } catch {
      print("Decryption error: \(error)")
      return nil
    }
  }
}

// Usage
//let encryption = SimpleEncryption.shared
//if let encryptedString = encryption.encrypt("Hello, World!") {
//  UserDefaults.standard.set(encryptedString, forKey: "myEncryptedString")
//}
//
//if let retrievedString = UserDefaults.standard.string(forKey: "myEncryptedString"),
//   let decryptedString = encryption.decrypt(retrievedString) {
//  print(decryptedString) // "Hello, World!"
//}
