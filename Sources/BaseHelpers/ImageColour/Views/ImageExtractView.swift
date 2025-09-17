//
//  ImageExtractExampleView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SceneKit
import SwiftUI

public struct ImageExtractWrapperView: View {

  @StateObject private var store = DominantColourHandler()
  public init() {}
  //    let fileURL = ThumbnailGenerator.downloadImageToDisk(from: "https://cdn2.steamgriddb.com/hero/9fb39fd910a6708e156d228c541bb278.png".toURL)
  //  }

  public var body: some View {

    ImageExtractView()
      .task {
        if store.imageFileURL == nil {
          guard
            let fileURL = await ThumbnailGenerator.downloadImageToDisk(
              from: "https://cdn2.steamgriddb.com/hero/9fb39fd910a6708e156d228c541bb278.png".toURL)
          else {
            print("No value for the image File URL")
            return
          }

          if !isPreview {
            store.setUp(fileURL)
          }
        }
      }
      .environmentObject(store)

  }
}

public struct ImageExtractView: View {

  @EnvironmentObject var store: DominantColourHandler

  public var body: some View {

    VStack {
      ZStack {
        if let img = store.image {
          Image(
            decorative: img.thumbnail,
            scale: 1
          )
          .resizable()
          .aspectRatio(contentMode: .fit)
          .disabled(store.isBusy)

        } else {
          ContentUnavailableView("No Thumbnail image found", systemImage: Icons.warning.icon)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: 300)
      .overlay(alignment: .bottomLeading) {
        HStack {
          Picker("Colours", selection: $store.k) {
            ForEach(1..<9, id: \.self) {
              Text("\($0)")
            }
          }
          .pickerStyle(.segmented)
          .labelsHidden()
          .disabled(store.isBusy)

          Spacer()

          Button("Run again") {
            store.calculateKMeans()
          }
          .disabled(store.isBusy)
        } // END hstack
        .padding()
      }
      .background(Color.black.quaternary)

      HSplitView {

        ImageResultView()

        DominantColoursView(colours: store.dominantColors, isBusy: store.isBusy)

        //        Divider()
        //        CentroidsView()

      }  // END main vstack
      .frame(maxWidth: .infinity, maxHeight: .infinity)

    }  // END main vstack
    .task(id: store.k) {
      store.didSetCentroids()
    }
  }
}
