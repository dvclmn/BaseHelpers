//
//  ParagraphStyle.swift
//  
//
//  Created by Matthew Davidson on 21/12/19.
//

import Foundation

#if os(iOS)
import UIKit
public typealias EditorParagraphStyle = NSParagraphStyle
public typealias EditorMutableParagraphStyle = NSMutableParagraphStyle

#elseif os(macOS)
import Cocoa
import AppKit
public typealias EditorParagraphStyle = NSParagraphStyle
public typealias EditorMutableParagraphStyle = NSMutableParagraphStyle

#endif
