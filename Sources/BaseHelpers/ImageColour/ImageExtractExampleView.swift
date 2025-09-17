//
//  ImageExtractExampleView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI
import SceneKit

public struct ImageExtractView: View {
  @State private var store: DominantColourHandler

  public init(imageURL: URL) {
    self._store = State(initialValue: DominantColourHandler(imageURL: imageURL))
  }

  public var body: some View {

    @Bindable var store = store
    NavigationSplitView {
//      List(
//        store.sourceImages,
//        selection: $store.selectedThumbnail
//      ) { thumbnail in
        
      if let img = store.image {
        Image(
          decorative: img.thumbnail,
          //          decorative: thumbnail.thumbnail,
          scale: 1
        )
        .resizable()
        .aspectRatio(contentMode: .fit)
//        .onTapGesture {
//          store.selectedThumbnail = thumbnail
//        }
//        .border(
//          store.selectedThumbnail == thumbnail ? .blue : .gray,
//          width: 4
//        )
        .disabled(store.isBusy)
        
      } else {
        ContentUnavailableView("No Thumbnail image found", systemImage: Icons.warning.icon)
      }
//      }
    } detail: {

      Divider()

      HStack {
        TabView {
          Image(decorative: store.sourceImage, scale: 1)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .tabItem {
              Label("Original image", systemImage: "photo")
            }

          Image(decorative: store.quantizedImage, scale: 1)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .tabItem {
              Label(
                "Quantized image (\(store.dimension) x \(store.dimension))",
                systemImage: "photo")
            }
        }
        .opacity(store.isBusy ? 0.5 : 1)
        .disabled(store.isBusy)
        .overlay {
          ProgressView()
            .opacity(store.isBusy ? 1 : 0)
        }

        Divider()

        SceneView(
          scene: store.scene,
          pointOfView: nil,
          options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .opacity(store.isBusy ? 0.5 : 1)
        .overlay {
          ProgressView()
            .opacity(store.isBusy ? 1 : 0)
        }
      }
      .padding()

      Divider()

      HStack {
        ForEach(store.dominantColors.sorted(by: >)) { dominantColor in
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
      .opacity(store.isBusy ? 0 : 1)

      Divider()

      HStack {

        Picker("Number of centroids", selection: $store.k) {
          ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], id: \.self) {
            Text("\($0)")
          }
        }
        .pickerStyle(.segmented)
        .disabled(store.isBusy)

        Spacer()

        Button("Run again") {
          store.calculateKMeans()
        }
        .disabled(store.isBusy)
      }
      .padding()
    }
    .padding()
  }
}
