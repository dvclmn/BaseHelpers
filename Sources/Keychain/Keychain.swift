//
//  File.swift
//  
//
//  Created by Dave Coleman on 26/7/2024.
//

import Foundation
@preconcurrency import KeychainSwift
import Dependencies

// MARK: - Keychain
public extension DependencyValues {
    var keychain: KeychainSwift {
        get { self[KeychainSwift.self] }
    }
}

extension KeychainSwift: @retroactive DependencyKey {
    public static let liveValue = KeychainSwift()
}

