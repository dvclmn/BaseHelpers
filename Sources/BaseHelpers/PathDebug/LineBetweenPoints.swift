//
//  LineBtweenPoints.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/5/2025.
//

import SwiftUI

public struct AngledLineConfig: Equatable {
  var p1: CGPoint
  var p2: CGPoint
  var lineColour: Color = .blue
  var lineWidth: CGFloat = 2
  var textColour: Color = .white
  var textBackgroundColour: Color = .black.opacity(0.7)
}

public struct AngleLineModifier: ViewModifier {
  let config: AngledLineConfig
  let debouncer = AsyncDebouncer(interval: 0.4)
  
  @State private var angleString: String = "—"

  public func body(content: Content) -> some View {
    content
      .overlay {
        Canvas {
          context,
          size in
          /// Draw line between the two points
          let path = Path { path in
            path.move(to: config.p1)
            path.addLine(to: config.p2)
          }

          context.stroke(
            path,
            with: .color(config.lineColour),
            lineWidth: config.lineWidth
          )

        }
        .overlay {
          Text(angleString)
            .position(CGPoint.midPoint(from: config.p1, to: config.p2))
        }
      }
      .task(id: config) {
        await debouncer.execute { @MainActor in
          let value = CGPoint.angleBetween(config.p1, config.p2).toDegrees.displayString
          angleString = value
        }
      }
  }
}

extension View {
  public func angledLine(
    from point1: CGPoint, to point2: CGPoint,
    lineColour: Color = .blue,
    lineWidth: CGFloat = 2,
    textColour: Color = .white,
    textBackgroundColour: Color = .black.opacity(0.7),
  ) -> some View {
    self.modifier(
      AngleLineModifier(
        config: AngledLineConfig(
          p1: point1,
          p2: point2,
          lineColour: lineColour,
          lineWidth: lineWidth,
          textColour: textColour,
          textBackgroundColour: textBackgroundColour
        )
      )
    )
  }
}


public struct ExampleLineBetweenView: View {

  let p1: CGPoint = .init(x: 200, y: 300)
  let p2: CGPoint = .init(x: 400, y: 600)

  public var body: some View {

    Text("Hello")
      .frame(width: 600, height: 700)
      .angledLine(from: p1, to: p2)

  }
}
#if DEBUG
#Preview {
  ExampleLineBetweenView()
}
#endif
