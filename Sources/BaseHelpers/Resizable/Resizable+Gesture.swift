//
//  Resizable+Gesture.swift
//  Collection
//
//  Created by Dave Coleman on 18/9/2024.
//

//import SwiftUI
//
//
//public struct ResizableGesturer: ViewModifier {
//  
//  var opacity: Double
//  
//  public func body(content: Content) -> some View {
//    content
//      .opacity(opacity)
//  }
//}
//
//
//extension Resizable {
//  
//  
//  
//  .gesture(
//    ExclusiveGesture(
//      DragGesture(minimumDistance: 0.5)
//        .onChanged { gesture in
//          
//          isManualMode = true
//          isResizing = true
//          
//          /// ALWAYS CLAMP HERE IN THE ONCHANGED
//          /// `min(max(lengthMin, manualLength), lengthMax)` etc
//          
//          var newValue: CGFloat = .zero
//          
//          switch edge {
//            case .top:
//              newValue = manualLength + gesture.translation.height * -1
//            case .bottom:
//              newValue = manualLength + gesture.translation.height
//            case .leading:
//              newValue = manualLength + gesture.translation.width * -1
//            case .trailing:
//              newValue = manualLength + gesture.translation.width
//          }
//          
//          manualLength = newValue.constrained(lengthMinConstrained, lengthMaxConstrained)
//          
//          /// Sending out the calculated length, as we actively resize
//          returnedLength(metrics, actualLength, .zero)
//          
//        } // END on changed
//      
//        .onEnded { _ in
//          
//          isHoveringLocal = false
//          isResizing = false
//          
//          returnedLength(metrics, actualLength, actualLength)
//          
//          if persistenceKey != nil {
//            
//            
//            //                                            updateSavedLength(to: Double(actualLength ?? 0))
//            
//          }
//        }
//      ,
//      /// Reset editor height to defaults
//      TapGesture(count: 2)
//        .onEnded {
//          isManualMode = false
//          isHoveringLocal = false
//          isResizing = false
//          
//          /// Important to set the manual length here so it's keeping up with the dynamic content, behind the scenes
//          manualLength = unwrappedContentLength
//          returnedLength(metrics, unwrappedContentLength, .zero)
//          //                                        savedLength = .zero
//        }
//    )
//  ) // END gesture
//  
//}
