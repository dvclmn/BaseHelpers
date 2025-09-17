//
//  ImageExtractExampleView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct ImageExtractView: View {

  @EnvironmentObject var store: DominantColourHandler

  public var body: some View {

    VSplitView {
      ZStack {
        if let img = store.sourceImage {
          Image(
            decorative: img,
            scale: 1
          )
          .resizable()
          .aspectRatio(contentMode: .fill)
          .disabled(store.isBusy)

        } else {
          ContentUnavailableView("No Source Image found", systemImage: Icons.warning.icon)
        }
      }
      .frame(
        maxWidth: .infinity,
        minHeight: 100,
        idealHeight: 200,
        maxHeight: .infinity,
      )
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
        }  // END hstack
        .padding()
      }
      .background(Color.black.quaternary)

      HSplitView {

        Group {
          ImageResultView()
          DominantColoursView(
            colours: store.dominantColors,
            isBusy: store.isBusy
          )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        //        Divider()
        //        CentroidsView()

      }  // END main vstack
      .frame(
        maxWidth: .infinity,
        minHeight: 100,
        idealHeight: 300,
        maxHeight: .infinity,
      )
    }  // END main vstack
    .task(id: store.k) {
      store.didSetCentroids()
    }
  }
}
