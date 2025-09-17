//
//  DominantColoursView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct DominantColoursView: View {
  //  @Environment(DominantColourHandler.self) private var store

  private let colourSize: CGFloat = 60

  let colours: [DominantColor]
  let isBusy: Bool
  public var body: some View {

    Group {
      if !colours.isEmpty {

        LazyVGrid(
          columns: .quickAdaptive(mode: .fill(min: 20, max: 120)),
          alignment: .leading,
          spacing: Styles.sizeSmall,
        ) {
          //    HStack {
          ForEach(colours.sorted(by: >)) { dominantColor in

            Rectangle()
              .fill(dominantColor.color)
              .frame(width: colourSize, height: colourSize)
              .overlay {
                Text("\(dominantColor.percentage)%")
              }
              .background(Color.black.opacityFaint)
              .clipShape(.rect(cornerRadius: Styles.sizeTiny))
            //          .aspectRatio(1, contentMode: .fit)
          }  // ENd foreach
        }  // END lazy grid

      } else {
        
        MiniStateView("Extracted Colours")
//        ContentUnavailableView("No colours extracted", systemImage: Icons.palette.icon)
//          .font(.callout)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .opacity(isBusy ? 0 : 1)
    //    .frame(minWidth: 100)

  }
}
