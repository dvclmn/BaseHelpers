//
//  Examples.swift
//  Components
//
//  Created by Dave Coleman on 11/12/2024.
//

import SwiftUI


struct RoughnessExampleView: View {
  
  @State private var roughness: Double = 2
  @State private var segments: Double = 10
  @State private var jitter: Double = 2
  
  var body: some View {
    
    
    VStack {
      
      
      
      RoundedRectangle(cornerRadius: 10)
        .roughen(roughness: roughness, segments: segments, jitter: jitter)
        .fill(.mint)
        .stroke(.indigo, style: .init(lineWidth: 2))
      
      Circle()
        .roughen(roughness: roughness, segments: segments, jitter: jitter)
        .fill(.orange)
        .stroke(.purple, style: .init(lineWidth: 2))
      
      Diamond()
        .roughen(roughness: roughness, segments: segments, jitter: jitter)
        .fill(.brown)
        .stroke(.blue, style: .init(lineWidth: 2))
      //            Circle()
      //              .roughStroke(
      //                style: .init(roughness: 2, segments: 30),
      //                lineWidth: 2,
      //                color: .blue
      //              )
      ////              .fill(.brown)
        .frame(width: 200)
      
      
//      SimpleSlider("Roughness", value: $roughness, range: 1...100)
//      SimpleSlider("Segments", value: $segments, range: 1...100)
//      SimpleSlider("Jitter", value: $jitter, range: 1...100)
    }
    .padding(60)
  }
}

//// In a Canvas
//struct CanvasExample: View {
//  var body: some View {
//    Canvas { context, size in
//      let path = Path { path in
//        path.addRect(CGRect(origin: .zero, size: size))
//      }
//      
//      context.roughStroke(
//        path,
//        style: RoughStrokeStyle(roughness: 15),
//        color: .blue,
//        lineWidth: 2
//      )
//    }
//  }
//}
