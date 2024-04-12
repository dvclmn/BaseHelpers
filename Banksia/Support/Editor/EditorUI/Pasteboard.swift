//
//  Pasteboard.swift
//  
//
//  Created by Matthew Davidson on 21/1/20.
//

import Foundation

#if os(iOS)
import UIKit
public typealias EditorPasteboard = UIPasteboard
public typealias EditorPasteboardType = UIPasteboard.Type
#elseif os(macOS)
import Cocoa
import AppKit
public typealias EditorPasteboard = NSPasteboard
public typealias EditorPasteboardType = NSPasteboard.PasteboardType
#endif
