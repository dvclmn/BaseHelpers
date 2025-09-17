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
//      Group {
      ImageView(store.image?.thumbnail, text: "Thumbnail Image")
      
      Divider()

      ImageView(store.quantizedImage, text: "Quantised Image")
//        if let quantImage = store.quantizedImage {
//          Image(decorative: quantImage, scale: 1)
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//
//        } else {
//          PlaceholderText("No Image loaded")
//          //        ContentUnavailableView("Couldn't get quantised image", systemImage: Icons.image.icon)
//        }
//      } // END group
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

extension ImageResultView {
  
  @ViewBuilder
  private func ImageView(_ image: CGImage?, text: String) -> some View {
    Group {
      if let image {
        Image(decorative: image, scale: 1)
          .resizable()
          .aspectRatio(contentMode: .fill)
        
      } else {
        MiniStateView(text)
        //        ContentUnavailableView("Couldn't get Image", systemImage: Icons.image.icon)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview {
  ImageExtractWrapperView()
    .frame(width: 600, height: 700)
}
#endif
