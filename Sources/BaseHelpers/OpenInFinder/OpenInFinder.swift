//
//  OpenInFinder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/6/2025.
//

import AppKit

#if canImport(AppKit)
public struct OpenInFinder {
  public static func `open`(_ url: URL) {
    NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: "")
  }
}
#endif
