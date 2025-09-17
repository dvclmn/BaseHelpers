//
//  ImageExtractExampleView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SceneKit
import SwiftUI

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
          let fileURL = await ThumbnailGenerator.downloadImageToDisk(from: "https://cdn2.steamgriddb.com/hero/9fb39fd910a6708e156d228c541bb278.png".toURL)
          store.imageFileURL = fileURL
        }
      }
      .environmentObject(store)
  
  }
}


public struct ImageExtractView: View {
//  @State private var store: DominantColourHandler
  
//  @Bindable var store: DominantColourHandler

//  public init(imageURL: URL) {
//    self._store = State(initialValue: DominantColourHandler(imageURL: imageURL))
//  }
//  
//  public init?(imageURLString: String) {
//    if let url = imageURLString.toURL {
//      self._store = State(initialValue: DominantColourHandler(imageURL: url))
//    } else {
//      return nil
//    }
//  }
  
  @EnvironmentObject var store: DominantColourHandler

  public var body: some View {

    HStack {
      if let img = store.image {
        Image(
          decorative: img.thumbnail,
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
        
//        .task(id: store.k) {
//          store.didSetCentroids()
//        }

      } else {
        ContentUnavailableView("No Thumbnail image found", systemImage: Icons.warning.icon)
      }

//      Divider()
//      ImageResultView()
//
//      Divider()
//      DominantColoursView(colours: store.dominantColors, isBusy: store.isBusy)
//
//      Divider()
//      CentroidsView()

    }  // END main vstack
    .padding()
  }
}

//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview {
//  ImageExtractView(imageURLString: "https://cdn2.steamgriddb.com/hero/9fb39fd910a6708e156d228c541bb278.png")
//}
//#endif
