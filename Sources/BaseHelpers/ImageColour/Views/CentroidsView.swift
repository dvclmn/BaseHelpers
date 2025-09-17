//
//  CentroidsView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct CentroidsView: View {
  @Environment(DominantColourHandler.self) private var store

  public var body: some View {
    @Bindable var store = store
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
}
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  BoxPrintView()
//}
//#endif
//
