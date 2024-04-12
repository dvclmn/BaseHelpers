//
//  Font.swift
//
//
//  Created by Matthew Davidson on 29/11/19.
//  
//

import Foundation

#if os(iOS)
import UIKit
public typealias EditorFont = UIFont

#elseif os(macOS)
import AppKit
import Cocoa
public typealias EditorFont = NSFont

#endif
