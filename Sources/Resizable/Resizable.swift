//
//  DragToResize.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//
import Foundation
import SwiftUI
import TestStrings
import OSLog
import BaseUtilities
import ReadSize


public struct Resizable: ViewModifier {
    
    /// If this value is not supplied, Resizable will default to averaging the min and max lengths to obtain an *ideal* length (as well as clamping to the min and max as well)
    var contentLength: CGFloat?
    
    /// This is `@Binding`, to allow users of Resizable to toggle manual mode (e.g. after sending a message, to 'reset' editor view)
    @Binding var isManualMode: Bool
    
    var edge: Edge
    var isResizable: Bool
    var isShowingFrames: Bool
    var isAnimated: Bool
    var handleColour: Color
    var handleSize: Double
    var handleVisibleWhenResized: Bool
    var lengthMin: CGFloat
    var lengthMax: CGFloat
    var shouldRememberLength: Bool
    /// DO NOT try to feed this value back to the property providing the `contentLength`, or it will get caught in a loop.
    ///`contentLength` is ingested, clamped, and returned below, so that other UI elements can recieve and respond to the length if need be
    var finalLength: (_ metrics: String, _ onChanged: CGFloat, _ onEnded: CGFloat) -> Void
    
    @State private var isHoveringLocal: Bool = false
    @State private var isResizing: Bool = false
    @State private var manualLength: CGFloat = .zero
    
    @AppStorage("resizableSavedLength") private var savedLength: Double = .zero
    
    private let grabArea: Double = 26
    private let unfocusedLengthReduction = 0.6
    private let animation = Animation.easeOut(duration: 0.2)
    private let grabAreaOuterPercentage = 0.3
    
    var unwrappedContentLength: CGFloat {
        if let contentLength = contentLength {
            return contentLength.constrained(lengthMin, lengthMax)
        } else {
            if shouldRememberLength && savedLength != .zero {
                return savedLength
            } else {
                return (lengthMin + lengthMax) * 0.5
            }
        }
    }
    
    var actualLength: CGFloat {
        if isManualMode {
            return manualLength.constrained(lengthMin, lengthMax)
        } else {
            return unwrappedContentLength
        }
    }
    
    
    
    public func body(content: Content) -> some View {
        
        var metrics: String {
            return """
            Supplied length:    \(String(format: "%0.f", contentLength ?? .zero))
            Inferred length:    \(String(format: "%0.f", unwrappedContentLength))
            Manual length:      \(String(format: "%0.f", manualLength))
            Final length:       \(String(format: "%0.f", actualLength))
            Min length:         \(String(format: "%0.f", lengthMin))
            Max length:         \(String(format: "%0.f", lengthMax))
            """
        }
        
        content
        .frame(maxWidth: .infinity, maxHeight: .infinity)

//            .animation(isAnimated ? animation : nil, value: actualLength)
            .overlay(alignment: edge.alignment) {
                if isResizable {
                    Grabber()
//                        .animation(isAnimated ? animation : nil, value: actualLength)
                        .gesture(
                            ExclusiveGesture(
                                DragGesture(minimumDistance: 0.5)
                                    .onChanged { gesture in
                                        
                                        isManualMode = true
                                        isResizing = true
                                        
                                        /// ALWAYS CLAMP HERE IN THE ONCHANGED
                                        /// `min(max(lengthMin, manualLength), lengthMax)` etc
                                        
                                        var newValue: CGFloat = .zero
                                        
                                        switch edge {
                                        case .top:
                                            newValue = manualLength + gesture.translation.height * -1
                                        case .bottom:
                                            newValue = manualLength + gesture.translation.height
                                        case .leading:
                                            newValue = manualLength + gesture.translation.width * -1
                                        case .trailing:
                                            newValue = manualLength + gesture.translation.width
                                        }
                                        
                                        manualLength = newValue.constrained(lengthMin, lengthMax)
                                        
                                        /// Sending out the calculated length, as we actively resize
                                        finalLength(metrics, actualLength, .zero)
                                        
                                    } // END on changed
                                
                                    .onEnded { _ in
                                        
                                        isHoveringLocal = false
                                        isResizing = false
                                        
                                        finalLength(metrics, actualLength, actualLength)
                                        
                                        if shouldRememberLength {
                                            savedLength = Double(actualLength)
                                        }
                                    }
                                ,
                                /// Reset editor height to defaults
                                TapGesture(count: 2)
                                    .onEnded {
                                        isManualMode = false
                                        isHoveringLocal = false
                                        isResizing = false
                                        
                                        /// Important to set the manual length here so it's keeping up with the dynamic content, behind the scenes
                                        manualLength = unwrappedContentLength
                                        finalLength(metrics, unwrappedContentLength, .zero)
                                        savedLength = .zero
                                    }
                            )
                        ) // END gesture
                    
                } // END isResizable check
            } // END overlay
        
            .onAppear {
                /// Get manual length ready to go, just in case
                manualLength = unwrappedContentLength
                finalLength(metrics, unwrappedContentLength, .zero)
            }
        
            .task(id: contentLength) {
                if !isManualMode {
                    /// This is here to ensure that when it comes time for manual length to take over, it should be already exactly the same value as the dynamic length
                    manualLength = unwrappedContentLength
                    finalLength(metrics, unwrappedContentLength, .zero)
                }

            }
            .frame(
                width: edge.axis == .horizontal ? actualLength : nil,
                height: edge.axis == .vertical ? actualLength : nil,
                alignment: edge.alignmentOpposite
            )
            .frame(
                minWidth: minWidth,
//                idealWidth: idealWidth,
                maxWidth: maxWidth,
                minHeight: minHeight,
//                idealHeight: idealHeight,
                maxHeight: maxHeight,
                alignment: edge.alignmentOpposite
            )
            .border(Color.green.opacity(isShowingFrames ? 0.2 : 0))
    }
}

extension Resizable {
    
    
    
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
    
//    var idealWidth: CGFloat? {
//        switch axis {
//        case .horizontal:
//            actualLength
//        case .vertical:
//                .infinity
//        }
//    }
    
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
    
//    var idealHeight: CGFloat? {
//        switch axis {
//        case .horizontal:
//                .infinity
//        case .vertical:
//            actualLength
//        }
//    }
    
    

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

public extension View {
    func resizable(
        contentLength: CGFloat? = nil,
        isManualMode: Binding<Bool>,
        edge: Edge = .top,
        isResizable: Bool = true,
        isShowingFrames: Bool = false,
        isAnimated: Bool = true,
        handleColour: Color = .white,
        handleSize: Double = 6,
        handleVisibleWhenResized: Bool = true,
        lengthMin: CGFloat,
        lengthMax: CGFloat,
        shouldRememberLength: Bool = false,
        finalLength: @escaping (_ metrics: String, _ onChanged: CGFloat, _ onEnded: CGFloat) -> Void = {metrics, onChanged, onEnded in }
        
    ) -> some View {
        self.modifier(
            Resizable(
                contentLength: contentLength,
                isManualMode: isManualMode,
                edge: edge,
                isResizable: isResizable,
                isShowingFrames: isShowingFrames,
                isAnimated: isAnimated,
                handleColour: handleColour,
                handleSize: handleSize,
                handleVisibleWhenResized: handleVisibleWhenResized,
                lengthMin: lengthMin,
                lengthMax: lengthMax,
                shouldRememberLength: shouldRememberLength,
                finalLength: finalLength
            )
        )
    }
}


extension Resizable {
    @ViewBuilder
    func Grabber() -> some View {
        
        var calculatedGrabArea: Double {
            grabArea * grabAreaOuterPercentage
        }
        
        var offset: CGSize {
            switch edge {
            case .top:
                CGSize(width: 0, height: calculatedGrabArea * -1)
            case .bottom:
                CGSize(width: 0, height: calculatedGrabArea)
            case .leading:
                CGSize(width: calculatedGrabArea * -1, height: 0)
            case .trailing:
                CGSize(width: calculatedGrabArea, height: 0)
            }
            
        }
        
        Color.clear
            .frame(
                width: edge.axis == .horizontal ? grabArea : nil,
                height: edge.axis == .vertical ? grabArea : nil
            )
            .background(.blue.opacity( isShowingFrames ? 0.2 : 0))
            .contentShape(Rectangle())
            .onHover { hovering in
                withAnimation(isAnimated ? animation : nil) {
                    isHoveringLocal = hovering
                }
            }
            .offset(offset)
            .background(alignment: edge.alignment) {
                handleColour.opacity(grabberOpacity)
                    .frame(
                        minWidth: edge.axis == .horizontal ? handleSize : nil,
                        maxWidth: edge.axis == .horizontal ? handleSize : .infinity,
                        minHeight: edge.axis == .vertical ? handleSize : nil,
                        maxHeight: edge.axis == .vertical ? handleSize : .infinity
                    )
            }
        
        
    }
    
    var grabberOpacity: Double {
        let baseOpacity: Double = 0.09
        let emphasisedOpacity: Double = 0.14
        
        
        if isManualMode {
            
            if isHoveringLocal {
                if handleVisibleWhenResized {
                    return emphasisedOpacity
                } else {
                    return baseOpacity
                }
            } else {
                if handleVisibleWhenResized {
                    return baseOpacity
                } else if isResizing {
                    return baseOpacity
                } else {
                    return 0
                }
            }
            
        } else {
            
            if isHoveringLocal {
                return baseOpacity
            } else {
                return 0
            }
            
        }
    }
}
