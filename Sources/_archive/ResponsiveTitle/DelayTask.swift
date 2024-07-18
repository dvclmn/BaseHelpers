//
//  Cursor.swift
//  
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation
import SwiftUI


public func delayed(_ delay: TimeInterval = 0.5, action: @escaping () -> Void) {
    Task {
        do {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            action()
        } catch {
            print("Couldn't delay. Don't know what to do with the thrown error")
        }
    }
}


