//
//  TrackpadTouch.swift
//  Collection
//
//  Created by Dave Coleman on 18/11/2024.
//

#if canImport(AppKit)
import SwiftUI
import AppKit


public protocol AppKitTouchesViewDelegate: AnyObject {
  /// Provides `.touching` touches only.
  func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>)
}

public final class AppKitTouchesView: NSView {
  weak var delegate: AppKitTouchesViewDelegate?
  
  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    /// We're interested in `.indirect` touches only.
    allowedTouchTypes = [.indirect]
    /// We'd like to receive resting touches as well.
    wantsRestingTouches = true
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func handleTouches(with event: NSEvent) {
    // Get all `.touching` touches only (includes `.began`, `.moved` & `.stationary`).
    let touches = event.touches(matching: .touching, in: self)
    // Forward them via delegate.
    delegate?.touchesView(self, didUpdateTouchingTouches: touches)
  }
  
  public override func touchesBegan(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesEnded(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesMoved(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesCancelled(with event: NSEvent) {
    handleTouches(with: event)
  }
}

public struct TrackPadTouch: Identifiable {

  public var id: Int
  
  /// Normalized touch X position on a device (0.0 - 1.0).
  public let normalizedX: CGFloat
  
  /// Normalized touch Y position on a device (0.0 - 1.0).
  public let normalizedY: CGFloat
  
  public init(_ nsTouch: NSTouch) {
    self.normalizedX = nsTouch.normalizedPosition.x
    /// `NSTouch.normalizedPosition.y` is flipped -> 0.0 means bottom. But the
    /// `Touch` structure is meants to be used with the SwiftUI -> flip it.
    self.normalizedY = 1.0 - nsTouch.normalizedPosition.y
    self.id = nsTouch.hash
  }
  
  public init(x: CGFloat, y: CGFloat) {
    self.id = UUID().hashValue
    self.normalizedX = x
    self.normalizedY = 1.0 - y
  }
}

public struct TouchesView: NSViewRepresentable {
  
  /// Up to date list of touching touches.
  @Binding public var touches: [TrackPadTouch]
  
  public init(
    touches: Binding<[TrackPadTouch]>
  ) {
    self._touches = touches
  }
  
  public func updateNSView(_ nsView: AppKitTouchesView, context: Context) {
  }
      
  public func makeNSView(context: Context) -> AppKitTouchesView {
    let view = AppKitTouchesView()
    view.delegate = context.coordinator
    return view
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, AppKitTouchesViewDelegate {
    let parent: TouchesView
    
    public init(_ view: TouchesView) {
      self.parent = view
    }
    
    public func touchesView(_ view: AppKitTouchesView, didUpdateTouchingTouches touches: Set<NSTouch>) {
      parent.touches = touches.map(TrackPadTouch.init)
    }
  }
}
#endif

//
//struct ExampleTrackpadView: View {
//  var body: some View {
//    TrackPadView()
//      .background(Color.gray)
//      .aspectRatio(1.6, contentMode: .fit)
//      .padding()
//      .frame(maxWidth: .infinity, maxHeight: .infinity)
//  }
//}
//
//#if DEBUG
//#Preview {
//  ExampleTrackpadView()
//}
//#endif
