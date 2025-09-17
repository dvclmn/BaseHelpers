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
      if !colours.isEmpty {
        
        Text("Number of colours: \(colours.count)")
        
        ForEach(colours.sorted(by: >)) { dominantColor in
          VStack {
            RoundedRectangle(cornerRadius: Styles.sizeSmall)
              .fill(dominantColor.color)
              .frame(height: 50)
            Text("\(dominantColor.percentage)%")
              .opacity(dominantColor.percentage == 0 ? 0 : 1)
          }
          //          .aspectRatio(1, contentMode: .fit)
        }  // ENd foreach

      } else {
        ContentUnavailableView("No colours extracted", systemImage: Icons.palette.icon)
      }
    }  // END hstack
    .opacity(isBusy ? 0 : 1)
    //    .frame(minWidth: 100)

  }
}
