//
//  KeychainHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation
import Security

class KeychainHandler {
    
    static func set(_ value: String, forKey key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ]
            SecItemDelete(query as CFDictionary)
            return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
        }
        return false
    }
    
    static func get(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data,
               let result = String(data: retrievedData, encoding: .utf8) {
                return result
            }
        }
        return nil
    }
    
    static func delete(forKey key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
