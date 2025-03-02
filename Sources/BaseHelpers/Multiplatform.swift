//
//  Multiplatform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/3/2025.
//

#if canImport(UIKit)
import UIKit

public typealias OSColor = UIColor
public typealias OSFont = UIFont

#elseif canImport(AppKit)
import AppKit

public typealias OSColor = NSColor
public typealias OSFont = NSFont

#endif
