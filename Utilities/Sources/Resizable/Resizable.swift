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

@propertyWrapper
struct DynamicKeyAppStorage<T: Codable> {
  private let key: String
  private let defaultValue: T
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get {
      let data = UserDefaults.standard.data(forKey: key)
      let value = data.flatMap { try? JSONDecoder().decode(T.self, from: $0) }
      return value ?? defaultValue
    }
    set {
      let data = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(data, forKey: key)
    }
  }
}


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
  var persistenceKey: String?
  
  /// Important: In your code (outside of this package), DO NOT try to feed this value
  /// `finalLength` back to the property providing the `contentLength`, or it
  /// will get caught in a loop. `contentLength` is ingested, clamped, and returned
  /// below, so that other UI elements can recieve and respond to the length if need be.
  var finalLength: (_ metrics: String, _ onChanged: CGFloat?, _ onEnded: CGFloat?) -> Void
  
  
  public init(
    contentLength: CGFloat?,
    isManualMode: Binding<Bool>,
    edge: Edge,
    isResizable: Bool,
    isShowingFrames: Bool,
    isAnimated: Bool,
    handleColour: Color,
    handleSize: Double,
    handleVisibleWhenResized: Bool,
    lengthMin: CGFloat,
    lengthMax: CGFloat,
    persistenceKey: String? = nil,
    finalLength: @escaping (_: String, _: CGFloat?, _: CGFloat?) -> Void
  ) {
    self.contentLength = contentLength
    self._isManualMode = isManualMode
    self.edge = edge
    self.isResizable = isResizable
    self.isShowingFrames = isShowingFrames
    self.isAnimated = isAnimated
    self.handleColour = handleColour
    self.handleSize = handleSize
    self.handleVisibleWhenResized = handleVisibleWhenResized
    self.lengthMin = lengthMin
    self.lengthMax = lengthMax
    self.persistenceKey = persistenceKey
    self.finalLength = finalLength
    
    
    if let key = persistenceKey {
      _savedLength = DynamicKeyAppStorage(key: key, defaultValue: .zero)
    }
    
  }
  
  
  @State var isHoveringLocal: Bool = false
  @State var isResizing: Bool = false
  @State private var manualLength: CGFloat = .zero
  
  @DynamicKeyAppStorage(key: "defaultKey", defaultValue: .zero) var savedLength: Double
  
  let grabArea: Double = 26
  private let unfocusedLengthReduction = 0.6
  let animation = Animation.easeOut(duration: 0.2)
  let grabAreaOuterPercentage = 0.3
  
  var lengthMinConstrained: CGFloat {
    lengthMin.constrained(.zero, .infinity)
  }
  var lengthMaxConstrained: CGFloat {
    lengthMax.constrained(.zero, .infinity)
  }
  
  var unwrappedContentLength: CGFloat {
    if let contentLength = contentLength {
      return contentLength.constrained(lengthMinConstrained, lengthMaxConstrained)
    } else {
      if persistenceKey != nil && savedLength != .zero {
        return max(savedLength, .zero)
      } else {
        return max((lengthMinConstrained + lengthMaxConstrained) * 0.5, .zero)
      }
    }
  }
  
  /// This is optional so that `isResizable` can return nil if false
  var actualLength: CGFloat? {
    if isResizable {
      if isManualMode {
        return manualLength.constrained(lengthMinConstrained, lengthMaxConstrained)
      } else {
        return unwrappedContentLength
      }
    } else {
      return nil
    }
  }
  
  
  
  public func body(content: Content) -> some View {
    
    var metrics: String {
      return """
            Supplied length:    \(String(format: "%0.f", contentLength ?? .zero))
            Inferred length:    \(String(format: "%0.f", unwrappedContentLength))
            Manual length:      \(String(format: "%0.f", manualLength))
            Final length:       \(String(format: "%0.f", actualLength ?? .zero))
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
                    
                    manualLength = newValue.constrained(lengthMinConstrained, lengthMaxConstrained)
                    
                    /// Sending out the calculated length, as we actively resize
                    finalLength(metrics, actualLength, .zero)
                    
                  } // END on changed
                
                  .onEnded { _ in
                    
                    isHoveringLocal = false
                    isResizing = false
                    
                    finalLength(metrics, actualLength, actualLength)
                    
                    if persistenceKey != nil {
                      
                      
                      //                                            updateSavedLength(to: Double(actualLength ?? 0))
                      
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
                    //                                        savedLength = .zero
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
    persistenceKey: String? = nil,
    finalLength: @escaping (_ metrics: String, _ onChanged: CGFloat?, _ onEnded: CGFloat?) -> Void = {metrics, onChanged, onEnded in }
    
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
        persistenceKey: persistenceKey,
        finalLength: finalLength
      )
    )
  }
}

