//
//  ExampleDebugView.swift
//  BaseComponents
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI


struct PathDebugExampleView: View {
  var body: some View {
    VStack(spacing: 40) {
      Text("ShapeDebugger")
        .foregroundStyle(.white)
      
      ShapeDebugger {
        RoundedRectangle(cornerRadius: 20)
      }
      .frame(width: 300, height: 200)
      
      Text("CanvasPathDebugger")
        .foregroundStyle(.white)
      
      CanvasPathDebugger(
        pathBuilder: { size in
          var path = Path()
          path.addRoundedRect(in: CGRect(origin: .zero, size: size), cornerSize: CGSize(width: 20, height: 20))
          return path
        },
        config: .init()
      )
//      .frame(width: 300, height: 200)
    }
    .padding(40)
    .frame(width: 580, height: 700)
    .background(.black.opacity(0.6))
  }
}
