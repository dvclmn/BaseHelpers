//
//  PathDebugger.swift
//  Components
//
//  Created by Dave Coleman on 30/9/2024.
//

import SwiftUI



public struct PathDebugger<T: Shape> {
  public let shape: T
  public let config: PathDebugConfig
  
  public func debugPaths(in rect: CGRect) -> DebugPaths {
    
    let originalPath = shape.path(in: rect)
    var nodePath = Path()
    var controlPointPath = Path()
    var connectionPath = Path()
//    var labels: [PointLabel] = []
//    var coloredNodes: [ColouredPoint] = []
//    var coloredControlPoints: [ColouredPoint] = []
    var lastNodePoint: CGPoint?
    
    print("PathDebugger: Starting path analysis")
    
    originalPath.forEach { element in
      switch element {
        case .move(let to):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          lastNodePoint = to
//          if let label = to.label { labels.append((to, label)) }
        case .line(let to):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          lastNodePoint = to
//          if let label = to.label { labels.append((to, label)) }
        case .quadCurve(let to, let control):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          addPoint(to: &controlPointPath, at: control, pointType: config.controlPoint)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: control)
          }
          connectionPath.move(to: control)
          connectionPath.addLine(to: to)
          lastNodePoint = to
//          if let label = to.label { labels.append((to, label)) }
//          if let label = control.label { labels.append((control, label)) }
        case .curve(let to, let control1, let control2):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          addPoint(to: &controlPointPath, at: control1, pointType: config.controlPoint)
          addPoint(to: &controlPointPath, at: control2, pointType: config.controlPoint)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: control1)
            connectionPath.move(to: to)
            connectionPath.addLine(to: control2)
          }
          lastNodePoint = to
//          if let label = to.label { labels.append((to, label)) }
//          if let label = control1.label { labels.append((control1, label)) }
//          if let label = control2.label { labels.append((control2, label)) }
        case .closeSubpath:
          break
      }
    }
    
    print("PathDebugger: Path analysis complete")
//    print("PathDebugger: Found \(labels.count) labels")
//    print("PathDebugger: Found \(coloredNodes.count) colored nodes")
//    print("PathDebugger: Found \(coloredControlPoints.count) colored control points")
    
    return DebugPaths(
      original: originalPath,
      nodes: nodePath,
      controlPoints: controlPointPath,
      connections: connectionPath
//      labels: labels,
//      coloredNodes: coloredNodes,
//      coloredControlPoints: coloredControlPoints
    )
  }
  
//  private func addPointWithLabel(to path: inout Path, at point: CGPoint, pointType: PointType, coloredPoints: inout [ColouredPoint], labels: inout [PointLabel]) {
//    addPoint(to: &path, at: point, pointType: pointType)
//    if let labeledPoint = point as? LabeledPoint {
//      coloredPoints.append((labeledPoint.point, labeledPoint.label.color))
//      labels.append((labeledPoint.point, labeledPoint.label))
//      print("PathDebugger: Found label '\(labeledPoint.label.text)' at \(labeledPoint.point)")
//    }
//  }
  
  private func addPoint(
    to path: inout Path,
    at point: CGPoint,
    pointType: PointType
  ) {
    let pointSize = config.pointSize.value
    
    let rect = CGRect(
      x: point.x - pointSize / 2,
      y: point.y - pointSize / 2,
      width: pointSize,
      height: pointSize)
    
    switch pointType.shape {
      case .circle:
        path.addEllipse(in: rect)
      case .square:
        path.addRect(rect)
    }
  }
}

//public struct PathDebugModifier<T: Shape>: ViewModifier {
//  
//  
//  
//  public func body(content: Content) -> some View {
//    
//  }
//}
//
//public extension View {
//  func debugShape<T: Shape>(
//    _ shape: T,
//    config: PathDebugConfig = .init()
//  ) -> some View {
//    let debugger = PathDebugger(
//      shape: shape,
//      config: config
//    )
//    if #available(macOS 15.0, *) {
//      return self.modifier(PathDebugModifier(debugger: debugger))
//    } else {
//      return self
//      // Fallback on earlier versions
//    }
//  }
//}


struct PathDebugExampleView: View {
  
  var body: some View {
    
    VStack {
      
      ShapeDebug {
        
        RoundedRectangle(cornerRadius: 20)
//        CustomBubbleShape(
//          cornerRadius: 70,
//          arrowHeight: 80,
//          arrowWidth: 180,
//          arrowPosition: 0.5,
//          arrowCurveAmount: 0.5
//        )
      }
      .frame(width: 300, height: 500)
    }
    .padding(40)
    .frame(width: 580, height: 700)
    .background(.black.opacity(0.6))
    
  }

}

public struct ShapeDebug<S: Shape>: View {
  
  public let debugger: PathDebugger<S>
  public let fill: Color
  public let shape: S
  
  public init(
    fill: Color = .blue.opacity(0.3),
    config: PathDebugConfig = .init(),
    @ViewBuilder shape: @escaping () -> S
  ) {
    self.fill = fill
    self.debugger = PathDebugger(shape: shape(), config: config)
    self.shape = shape()
  }
  
  public var body: some View {
    shape
      .fill(fill)
    .overlay(
      GeometryReader { geometry in
        let paths = debugger.debugPaths(in: geometry.frame(in: .local))
        ZStack {
          paths.original.stroke(debugger.config.stroke.colour, lineWidth: debugger.config.stroke.width)
          
          paths.connections.stroke(debugger.config.controlPoint.guideColour, lineWidth: debugger.config.stroke.width)
          
          // Default nodes
          paths.nodes.fill(debugger.config.node.colour)
          
          // Colored nodes
          //          ForEach(paths.coloredNodes, id: \.point) { node in
          //            Circle()
          //              .fill(node.color)
          //              .frame(width: debugger.config.pointSize.value, height: debugger.config.pointSize.value)
          //              .position(node.point)
          //          }
          
          // Default control points
          paths.controlPoints.fill(debugger.config.controlPoint.colour)
          
          // Colored control points
          //          ForEach(paths.coloredControlPoints, id: \.point) { controlPoint in
          //            Circle()
          //              .fill(controlPoint.color)
          //              .frame(width: debugger.config.pointSize.value, height: debugger.config.pointSize.value)
          //              .position(controlPoint.point)
          //          }
          
          //          paths.nodes.stroke(debugger.config.node.colour, lineWidth: debugger.config.stroke.width)
          
          
          //          paths.controlPoints.stroke(debugger.config.controlPoint.colour, lineWidth: debugger.config.stroke.width)
          
          // Labels
          //          ForEach(paths.labels, id: \.point) { labelInfo in
          //            Text(labelInfo.label.text)
          //              .font(.system(size: debugger.config.labelFontSize))
          //              .foregroundColor(labelInfo.label.colour)
          //              .position(labelInfo.point.offsetBy(dx: 0, dy: -debugger.config.pointSize.value))
          //          }
          
          
          
        } // END zstack
      } // END geo reader
    )
    
  }
}


#Preview {
  PathDebugExampleView()
}


struct CustomShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let start = CGPoint(x: rect.minX, y: rect.midY)
    let end = CGPoint(x: rect.maxX, y: rect.midY)
    let control = CGPoint(x: rect.midX, y: rect.minY)
    
    path.move(to: start)
    path.addQuadCurve(to: end, control: control)
    
    return path
  }
}
