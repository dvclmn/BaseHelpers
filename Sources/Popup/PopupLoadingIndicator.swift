// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

//public struct Percentage {
//    private(set) var value: Double
//    
//    public init?(_ value: Double) {
//        guard value >= 0.0, value <= 1.0 else {
//            return nil
//        }
//        self.value = value
//    }
//}

public struct PopupLoadingIndicatorView: View {
    
    var progressBarWidth: Double?
    var progressDescription: String?
    
    let icon: String
    let speed: TimeInterval
    
    let hasBackground: Bool
    
    @State private var isRotating = 0.0
    
    let maxWidth: Double = 220
    let minWidth: Double = 180
    
    let height: Double = 56
    
    let progressHeight: Double = 4
    
    let rounding: Double = 10
    
    public init(
        progressBarWidth: Double? = nil,
        progressDescription: String? = nil,
        icon: String = "rays",
        speed: TimeInterval = 2,
        hasBackground: Bool = true
    ) {
        self.progressBarWidth = progressBarWidth
        self.progressDescription = progressDescription
        self.icon = icon
        self.speed = speed
        self.hasBackground = hasBackground
    }
    
    public var body: some View {
        
        if let width = progressBarWidth {
        
        let animation = Animation.linear(duration: speed).repeatForever(autoreverses: false)
        
        VStack(spacing: 6) {
            
            Label {
                Text(progressDescription ?? "Loading")
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(.tertiary)
                    .rotationEffect(.degrees(isRotating))
                    .animation(animation, value: isRotating)
                    .frame(width: 20)
            }
            GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: geo.size.width * width, height: height)
                        .opacity(0.4)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: progressHeight,
                alignment: .leading
            )
            .onAppear {
                isRotating = 360.0
            }
            
            
            
        } // END vstack
        .padding(.horizontal, 20)
        .transition(.opacity)
        .frame(
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: height,
            maxHeight: height
        )
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: rounding)
                    .fill(.ultraThinMaterial)
            }
        )
        
        } // END check for progress width
    }
}

#Preview {
    PopupLoadingIndicatorView(
        progressBarWidth: 0.2,
        progressDescription: "Encoding data…"
    )
    .frame(width: 500, height: 700)
    .background(.black.opacity(0.8))
}



