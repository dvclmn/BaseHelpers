//
//  SwatchGalleryView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/8/2025.
//


import SwiftUI


public struct SwatchGalleryView: View {
  
  public var body: some View {
    
    LazyVGrid(
      columns: .quickAdaptiveColumns(min: 20),
      alignment: .center,
      spacing: 20,
      pinnedViews: <#T##PinnedScrollableViews#>,
    ) {
      ForEach(Swatch.allCases) { swatch in
        RoundedRectangle(cornerRadius: 6)
          .fill(swatch.swiftUIColor)
      }
    }
    
  }
}
#if DEBUG
#Preview {
  SwatchGalleryView()
}
#endif

