//
//  OpenInFinder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/6/2025.
//


#if canImport(AppKit)
import AppKit
public struct OpenInFinder {
  public static func `open`(_ url: URL) {
    NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: "")
  }
}
#endif
