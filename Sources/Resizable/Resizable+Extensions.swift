//
//  File.swift
//
//
//  Created by Dave Coleman on 26/7/2024.
//

#if canImport(AppKit)

import SwiftUI


extension Resizable {
    
    
//    mutating func updateSavedLength(to newValue: Double) {
//        savedLength = max(0, newValue) // Ensure the length is not negative
//    }
    
    
    /// 1. Is this a `Vertical` or `Horizontal` Resizable?
    ///     Horizontal = like a sidebar, resizes on the X-axis
    ///     Vertical = like the Markdown Editor, resizes on the Y-axis
    /// 2. Is there an explicit length supplied from this view, or should it be inferred?
    ///     Every Resizable needs some length to fall back on, when not in manual mode
    
    var minWidth: CGFloat? {
      
        switch edge.axis {
        case .horizontal:
            isManualMode ? actualLength : lengthMin
        case .vertical:
            /// Doesn't make sense to impose any specific value on the width for vertical Resizables — expect just maxWidth infinity
            /// The min and max lengths that Resizable asks for, are only to constrain the specificed axis. Vertical does not need Horizontal constraints, and vice versa
            nil
        }
    }
    
    var maxWidth: CGFloat? {
        switch edge.axis {
        case .horizontal:
            /// Having the maxWidth default to `lengthMax` at first felt intuitively correct, BUT it was 'reserving' it's space, when it should have been taking it's width from the proper calculated values above like `unwrappedContentLength` and `actualLength`. So now, setting it to `nil` gets the right result.
            isManualMode ? actualLength : nil
        case .vertical:
            nil
        }
    }
    
    var minHeight: CGFloat? {
        switch edge.axis {
        case .horizontal:
            nil
            
        case .vertical:
            isManualMode ? actualLength : lengthMin
        }
    }
    
    var maxHeight: CGFloat? {
        switch edge.axis {
        case .horizontal:
            nil
            
        case .vertical:
            isManualMode ? actualLength : nil
        }
    }

    
}


public extension Edge {
    
    var axis: Axis {
        switch self {
        case .top, .bottom:
                .vertical
        case .leading, .trailing:
                .horizontal
        }
    }
    
    var edgeSet: Edge.Set {
        switch self {
        case .top:
                .top
        case .bottom:
                .bottom
        case .leading:
                .leading
        case .trailing:
                .trailing
        }
    }
    
    var alignmentOpposite: Alignment {
        switch self {
        case .top:
                .bottom
        case .bottom:
                .top
        case .leading:
                .trailing
        case .trailing:
                .leading
        }
    }
    
    var alignment: Alignment {
        switch self {
        case .top:
                .top
        case .bottom:
                .bottom
        case .leading:
                .leading
        case .trailing:
                .trailing
        }
    }
}

#endif
