//
//  Color.swift
//
//
//  Created by Matthew Davidson on 28/11/19.
//

import Foundation

#if os(iOS)
import UIKit
public typealias EditorColor = UIColor
#elseif os(macOS)
import Cocoa
import AppKit
public typealias EditorColor = NSColor
#endif
