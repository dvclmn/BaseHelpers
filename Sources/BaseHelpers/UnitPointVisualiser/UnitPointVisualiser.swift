//
//  UnitPointVisualiser.swift
//  Components
//
//  Created by Dave Coleman on 23/9/2024.
//

import SwiftUI

@Observable
final class UnitPointHandler {
  var startPoint = UnitPoint(x: 0.25, y: 0.25)
  var endPoint = UnitPoint(x: 0.75, y: 0.75)
}

public struct UnitPointVisualizer: View {
  @State private var store = UnitPointHandler()
  
  public var body: some View {
    
    @Bindable var store = store
    
    VStack {
      ZStack {
        Rectangle()
          .fill(.clear)
          .aspectRatio(1, contentMode: .fit)
          .overlay {
            GestureControlsView()
          }
                    .background {
            /// White stroke
            LinearGradient(
              colors: [
                .red.opacity(0.9),
                .red.opacity(0.1),
              ],
              startPoint: store.startPoint,
              endPoint: store.endPoint
            )
          }
          .background {
            /// Dark stroke
            LinearGradient(
              colors: [
                .green.opacity(0.1),
                .green.opacity(0.9),
              ],
              startPoint: store.startPoint,
              endPoint: store.endPoint
            )
          }
      }
      .frame(height: 300)

      VStack {
        //        Text("Start Point: \(startPoint)")
        Text("X: \(store.startPoint.x, specifier: "%.2f")")
        Slider(value: $store.startPoint.x)
        Text("Y: \(store.startPoint.y, specifier: "%.2f")")
        Slider(value: $store.startPoint.y)

        Divider().padding()

        //        Text("End Point: \(endPoint)")
        Text("X: \(store.endPoint.x, specifier: "%.2f")")
        Slider(value: $store.endPoint.x)
        Text("Y: \(store.endPoint.y, specifier: "%.2f")")
        Slider(value: $store.endPoint.y)
      }
      .padding()
    }
    .environment(store)
  }
}

#if DEBUG

#Preview("UnitPoint Visualiser") {
  UnitPointVisualizer()
    .frame(width: 400, height: 700)
}
#endif
