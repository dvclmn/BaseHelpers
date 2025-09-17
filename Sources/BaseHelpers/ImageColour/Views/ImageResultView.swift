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

    HStack {
      TabView {
        if let image = store.sourceImage {
          Image(decorative: image, scale: 1)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .tabItem {
              Label("Original image", systemImage: "photo")
            }
          
        } else {
          ContentUnavailableView("Couldn't get source image", systemImage: Icons.image.icon)
          
        }

        if let quantImage = store.quantizedImage {
          Image(decorative: quantImage, scale: 1)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .tabItem {
              Label(
                "Quantized image (\(store.dimension) x \(store.dimension))",
                systemImage: "photo")
            }
          
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

//      Divider()

      //      SceneView(
      //        scene: store.scene,
      //        pointOfView: nil,
      //        options: [.allowsCameraControl, .autoenablesDefaultLighting]
      //      )
      //      .opacity(store.isBusy ? 0.5 : 1)
      //      .overlay {
      //        ProgressView()
      //          .opacity(store.isBusy ? 1 : 0)
      //      }
    }
    .padding()

  }
}
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  BoxPrintView()
//}
//#endif
//
