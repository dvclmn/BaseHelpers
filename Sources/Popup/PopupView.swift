//
//  PopupHandler.swift
//  Eucalypt
//
//  Created by Dave Coleman on 24/3/2024.
//
//
//  PopupMessageView.swift
//  Eucalypt
//
//  Created by Dave Coleman on 5/2/2024.
//

import SwiftUI
import Dependencies

@MainActor
public struct PopupView: View {
  
  @Dependency(\.popup) private var popup
  
  let location: PopupLocation
  let rounding: Double
  let topOffset: Double
  let isCompact: Bool
  
  let maxWidth: Double = 240
  let minWidth: Double = 180
  
  public init(
    location: PopupLocation = .main,
    rounding: Double = 10,
    topOffset: Double = 22,
    isCompact: Bool = false
  ) {
    self.location = location
    self.rounding = rounding
    self.topOffset = topOffset
    self.isCompact = isCompact
  }
  
  public var body: some View {
    
    if let message = popup.popupMessage, self.location == message.location {
      Popup(message)
    }
  }
}

extension PopupView {
  @ViewBuilder
  func Popup(_ message: PopupMessage) -> some View {
    VStack(spacing: isCompact ? 4 : 6) {
      if message.isLoading {
        PopupLoadingIndicatorView()
      } else {
        
        Text(message.title)
          .foregroundStyle(.primary.opacity( isCompact ? 0.8 : 1.0))
          .font(.system(size: isCompact ? 11 : 14))
          .fontWeight(.medium)
        
        if let message = message.message {
          
          Text(message)
            .foregroundStyle(.secondary)
            .font(.caption)
          
        } // END popup showing check
        
      } // END loading check
    } // END vstack
    .multilineTextAlignment(.leading)
    .fixedSize(horizontal: false, vertical: true)
    .padding(.horizontal, isCompact ? 12 : 20)
    .padding(.top, isCompact ? 8 : 13)
    .padding(.bottom, isCompact ? 10 : 15)
    .background(
      ZStack {
        RoundedRectangle(cornerRadius: rounding)
          .fill(.ultraThinMaterial)
      }
    )
    .padding(.top, topOffset)
    .transition(.opacity)
  }
}

@MainActor
struct PopupTestView: View {
  
  @State private var popup = PopupHandler()
  
  var body: some View {
    
    Button {
      popup.showPopup(title: "It's a test")
      
    } label: {
      Text("Test popup")
    }
    
    RoundedRectangle(cornerRadius: 12)
      .fill(.red.opacity(0.05))
      .overlay(alignment: .top) {
        PopupView()
      }
      .padding()
      .frame(width: 500, height: 400)
      .background(.black.opacity(0.4))
    
  }
}


#Preview("Popup message") {
  
  PopupTestView()
}
