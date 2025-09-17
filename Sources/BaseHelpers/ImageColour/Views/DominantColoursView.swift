//
//  DominantColoursView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct DominantColoursView: View {
//  @Environment(DominantColourHandler.self) private var store
  
  let colours: [DominantColor]
  let isBusy: Bool
  public var body: some View {
    
    HStack {
      ForEach(colours.sorted(by: >)) { dominantColor in
        VStack {
          RoundedRectangle(cornerSize: .init(width: 5, height: 5))
            .fill(dominantColor.color)
            .frame(height: 50)
          Text("\(dominantColor.percentage)%")
            .opacity(dominantColor.percentage == 0 ? 0 : 1)
        }
      }
    }
    .padding()
    .opacity(isBusy ? 0 : 1)
    
  }
}
