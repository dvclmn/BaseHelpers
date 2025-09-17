//
//  ImageResultView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SceneKit
import SwiftUI

public struct ImageResultView: View {
  @EnvironmentObject var store: DominantColourHandler

  public var body: some View {

    VStack {
      if let image = store.sourceImage {
        Image(decorative: image, scale: 1)
          .resizable()
          .aspectRatio(contentMode: .fit)

      } else {
        ContentUnavailableView("Couldn't get source image", systemImage: Icons.image.icon)
      }

      if let quantImage = store.quantizedImage {
        Image(decorative: quantImage, scale: 1)
          .resizable()
          .aspectRatio(contentMode: .fit)

      } else {
        ContentUnavailableView("Couldn't get quantised image", systemImage: Icons.image.icon)
      }
    }
    .opacity(store.isBusy ? 0.5 : 1)
    .disabled(store.isBusy)
    .overlay {
      ProgressView()
        .opacity(store.isBusy ? 1 : 0)
    }
//    .padding()

  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview {
  ImageExtractWrapperView()
    .frame(width: 600, height: 700)
}
#endif
