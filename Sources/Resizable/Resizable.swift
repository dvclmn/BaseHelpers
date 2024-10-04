//
//  DragToResize.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//
import Foundation
import SwiftUI
import OSLog
import BaseHelpers
import Geometry
import Shortcuts

public struct Resizable: ViewModifier {
  
  @Environment(\.modifierKeys) var modifiers
  
  /// If this value is not supplied, Resizable will default to averaging the min and max lengths to obtain an *ideal* length (as well as clamping to the min and max as well)
  var contentLength: CGFloat?
  
  /// This is `@Binding`, to allow users of Resizable to toggle manual mode (e.g. after sending a message, to 'reset' editor view)
  @Binding var isManualMode: Bool
  
  /// Defines the dimension along which the view should be resizable
  var edge: Edge
  
  /// Useful for toggling resizability on/off.
  var isResizable: Bool
  
  var isShowingFrames: Bool
  var isAnimated: Bool
  var handleColour: Color
  var accentColour: Color
  var handleSize: Double
  var handleVisibleWhenResized: Bool
  var lengthMin: CGFloat
  var lengthMax: CGFloat
  
  /// If provided, this enables persisting the resized length to UserDefaults
  var persistenceKey: String?
  
  /// Important: In your code (outside of this package), DO NOT try to feed this value
  /// `returnedLength` back to the property providing the `contentLength`, or it
  /// will get caught in a loop. `contentLength` is ingested, clamped, and returned
  /// below, so that other UI elements can recieve and respond to the length if need be.
  var returnedLength: (_ metrics: String, _ onChanged: CGFloat, _ onEnded: CGFloat) -> Void
  
  let dismissShapeRightInset: CGFloat = 10
  let dismissShapeSize = CGSize(width: 120, height: 17)
  
  public init(
    contentLength: CGFloat?,
    isManualMode: Binding<Bool>,
    edge: Edge,
    isResizable: Bool,
    isShowingFrames: Bool,
    isAnimated: Bool,
    accentColour: Color,
    handleColour: Color,
    handleSize: Double,
    handleVisibleWhenResized: Bool,
    lengthMin: CGFloat,
    lengthMax: CGFloat,
    persistenceKey: String? = nil,
    returnedLength: @escaping (_: String, _: CGFloat, _: CGFloat) -> Void
  ) {
    self.contentLength = contentLength
    self._isManualMode = isManualMode
    self.edge = edge
    self.isResizable = isResizable
    self.isShowingFrames = isShowingFrames
    self.isAnimated = isAnimated
    self.accentColour = accentColour
    self.handleColour = handleColour
    self.handleSize = handleSize
    self.handleVisibleWhenResized = handleVisibleWhenResized
    self.lengthMin = lengthMin
    self.lengthMax = lengthMax
    self.persistenceKey = persistenceKey
    self.returnedLength = returnedLength
    
    
    if let key = persistenceKey {
      _savedLength = DynamicKeyAppStorage(key: key, defaultValue: .zero)
    }
    
  }
  
  
  @State var isHoveringLocal: Bool = false
  @State var isResizing: Bool = false
  
  /// This state property is used to hold an 'actively resized' length value.
  /// `Resizable` has a few features that don't actually pertain to *resizing*
  /// a view specifically (such as averaging min and max lengths, clamping etc).
  ///
  /// However, the below deals directly/exclusively with the length as it is
  /// resized by the user.
  ///
  @State private var manualLength: CGFloat = .zero
  
  @DynamicKeyAppStorage(key: "defaultKey", defaultValue: .zero) var savedLength: Double
  
  let grabArea: Double = 34
  private let unfocusedLengthReduction = 0.6
  let animation = Animation.easeOut(duration: 0.2)
  let grabAreaOuterPercentage = 0.3
  
  /// These two computed properties ensure that `lengthMin`
  /// and `lengthMax` both sit safely between a minimum of
  /// `zero`, and a maximum of `infinity`.
  var lengthMinConstrained: CGFloat {
    lengthMin.constrained(.zero, .infinity)
  }
  var lengthMaxConstrained: CGFloat {
    lengthMax.constrained(.zero, .infinity)
  }
  
  /// "Unwrapped" here refers to taking the optional value of
  /// `contentLength`, and deciding concretely on how to
  /// handle it's value, or lack of value.
  ///
  var unwrappedContentLength: CGFloat {
    
    if let contentLength = contentLength {
      /// The user has provided a desired length. All we need to do is
      /// constrain it between the provided min and max lengths.
      return contentLength.constrained(lengthMinConstrained, lengthMaxConstrained)
    } else {
      if persistenceKey != nil && savedLength != .zero {
        /// Still superstitiously wrapping in `max()`, despite the above
        /// non-zero check, to insure against negative values
        return max(savedLength, .zero)
      } else {
        /// There was no previously saved value in UserDefaults,
        /// nor was there a specific provided `contentLength`.
        /// So we calculate a simple 'ideal' length, by averaging the
        /// (mandatory) provided min and max lengths.
        let idealLength: CGFloat = (lengthMinConstrained + lengthMaxConstrained) * 0.5
        return max(idealLength, .zero)
      }
    }
  }
  
  /// This is optional so that `isResizable` can return nil if false
  var actualLength: CGFloat {
    if isResizable {
      if isManualMode {
        return manualLength.constrained(lengthMinConstrained, lengthMaxConstrained)
      } else {
        return unwrappedContentLength
      }
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
            Min constr. length:         \(String(format: "%0.f", lengthMinConstrained))
            Max length:         \(String(format: "%0.f", lengthMax))
            Max constr. length:         \(String(format: "%0.f", lengthMaxConstrained))
            """
    }
    
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    
      .animation(isAnimated ? (isResizing ? nil : animation) : nil, value: actualLength)
      .overlay(alignment: edge.alignment) {
        if isResizable {
          Grabber()
            .gesture(
              ExclusiveGesture(
                DragGesture(minimumDistance: 0.5)
                  .onChanged { gesture in
                    
                    isManualMode = true
                    isResizing = true
                    let lengthBeforeResize: CGFloat = actualLength
                    
                    var newValue: CGFloat = .zero
                    
                    /// This switch allows us to only care about translation values along a certain axis
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
                    
                    /// Feed the new value to `manualLength`, always clamping to the provided min and max lengths
                    manualLength = newValue.constrained(lengthMinConstrained, lengthMaxConstrained)
                    
                    /// Sending out the calculated length, as we actively resize
                    /// `(_ metrics: String, _ onChanged: CGFloat, _ onEnded: CGFloat)`
                    returnedLength(metrics, actualLength, lengthBeforeResize)
                    
                  } // END on changed
                
                  .onEnded { _ in
                    
                    isHoveringLocal = false
                    isResizing = false
                    
                    returnedLength(metrics, actualLength, actualLength)
                    
                    if persistenceKey != nil {
                      
                      
//                                                                  updateSavedLength(to: Double(actualLength ?? 0))
                      
                    }
                  }
                ,
                /// Double tap to reset editor height to it's innate, unresized height
                TapGesture(count: 2)
                  .onEnded {
                    isManualMode = false
                    isHoveringLocal = false
                    isResizing = false
                    
                    /// Important to set the manual length here so it's keeping up with the dynamic content, behind the scenes
                    manualLength = unwrappedContentLength
                    returnedLength(metrics, unwrappedContentLength, .zero)
                    //                                        savedLength = .zero
                  }
              )
            ) // END gesture
          
        } // END isResizable check
      } // END overlay
    
      .onAppear {
        /// Get manual length ready to go, just in case
        manualLength = unwrappedContentLength
        returnedLength(metrics, unwrappedContentLength, unwrappedContentLength)
      }
    
      .task(id: contentLength) {
        if !isManualMode {
          /// This is here to ensure that when it comes time for manual length to take over, it should be already exactly the same value as the dynamic length
          manualLength = unwrappedContentLength
          returnedLength(metrics, unwrappedContentLength, .zero)
        }
        
      }
      .frame(
        width: edge.axis == .horizontal ? actualLength : nil,
        height: edge.axis == .vertical ? actualLength : nil,
        alignment: edge.alignmentOpposite
      )
      .frame(
        minWidth: self.minWidth,
        maxWidth: self.maxWidth,
        minHeight: self.minHeight,
        maxHeight: self.maxHeight,
        alignment: self.edge.alignmentOpposite
      )
      .border(Color.green.opacity(isShowingFrames ? 0.2 : 0))
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
    accentColour: Color = .accentColor,
    handleColour: Color = .white,
    handleSize: Double = 6,
    handleVisibleWhenResized: Bool = true,
    lengthMin: CGFloat,
    lengthMax: CGFloat,
    persistenceKey: String? = nil,
    returnedLength: @escaping (_ metrics: String, _ onChanged: CGFloat, _ onEnded: CGFloat) -> Void = {metrics, onChanged, onEnded in }
    
  ) -> some View {
    self.modifier(
      Resizable(
        contentLength: contentLength,
        isManualMode: isManualMode,
        edge: edge,
        isResizable: isResizable,
        isShowingFrames: isShowingFrames,
        isAnimated: isAnimated,
        accentColour: accentColour,
        handleColour: handleColour,
        handleSize: handleSize,
        handleVisibleWhenResized: handleVisibleWhenResized,
        lengthMin: lengthMin,
        lengthMax: lengthMax,
        persistenceKey: persistenceKey,
        returnedLength: returnedLength
      )
    )
  }
}

