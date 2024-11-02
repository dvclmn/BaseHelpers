//
//  IsPreview.swift
//  Collection
//
//  Created by Dave Coleman on 2/11/2024.
//

import SwiftUI

// MARK: - Check if is Preview
public var isPreview: Bool {
  return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}


