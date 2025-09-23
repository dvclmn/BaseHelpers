//
//  Keychain.swift
//  Collection
//
//  Created by Dave Coleman on 8/1/2025.
//

import SwiftUI
import KeychainSwift

/// http://github.com/evgenyneu/keychain-swift
public extension EnvironmentValues {
  @Entry var keychain: KeychainSwift = .init()
}



