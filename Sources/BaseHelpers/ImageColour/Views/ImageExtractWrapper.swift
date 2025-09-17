//
//  ImageExtractWrapper.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct ImageExtractWrapperView: View {

  @StateObject private var store = DominantColourHandler()
  public init() {}

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

//          if !isPreview {
            store.setUp(fileURL)
//          }
        }
      }
      .environmentObject(store)

  }
}
