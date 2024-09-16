//
//  Clipboard.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation

// MARK: - Copy to clipboard
public protocol PasteboardCopying {
    func setString(_ string: String)
}

#if canImport(AppKit)
import AppKit

extension NSPasteboard: PasteboardCopying {
    public func setString(_ string: String) {
        clearContents()
        setString(string, forType: .string)
    }
}

#elseif canImport(UIKit)
import UIKit

extension UIPasteboard: PasteboardCopying {
    public func setString(_ string: String) {
        self.string = string
    }
}
#endif

/// Usage
public func copyStringToClipboard(_ contents: String) {
    let pasteboard: PasteboardCopying
#if canImport(AppKit)
    pasteboard = NSPasteboard.general
#elseif canImport(UIKit)
    pasteboard = UIPasteboard.general
#endif
    pasteboard.setString(contents)
}






