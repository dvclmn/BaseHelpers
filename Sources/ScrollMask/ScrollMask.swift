//
//  File.swift
//  
//
//  Created by Dave Coleman on 26/6/2024.
//

import Foundation
import SwiftUI
import SmoothGradient

public struct ScrollMask: ViewModifier {
    
    var isEffectActive: Bool
    var maskMode: MaskMode
    
    var edge: Edge
    
    var opacity: Double
    var length: CGFloat
    
    var offset: CGFloat

    public func body(content: Content) -> some View {
    
            switch maskMode {
            case .mask:
                content
                    .mask {
                        MaskEffect()
                            .allowsHitTesting(false)
                    }
            case .overlay:
                content
                    .overlay {
                        MaskEffect()
                            .blendMode(.multiply)
                            .allowsHitTesting(false)
                    }
            }

    }
    
    @ViewBuilder
    func MaskEffect() -> some View {

        switch edge {
        case .top:
            VStack(spacing: 0) {
                MaskGradient(opacity: opacity)
                MaskBlock()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            
        case .leading:
            HStack(spacing: 0) {
                MaskGradient(opacity: opacity)
                MaskBlock()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
        case .bottom:
            VStack(spacing: 0) {
                MaskBlock()
                MaskGradient(opacity: opacity)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            
        case .trailing:
            HStack(spacing: 0) {
                MaskBlock()
                MaskGradient(opacity: opacity)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        
    }
    
    @ViewBuilder
    func MaskBlock() -> some View {
        if maskMode == .mask {
            Rectangle()
                .fill(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func MaskGradient(opacity: Double) -> some View {

        ZStack {
            LinearGradient(
                colors: [
                    .black.opacity(startOpacity),
                    .black.opacity(endOpacity)
                        ],
                startPoint: edge.off,
                endPoint: isEffectActive ? edge.on : edge.off
            )
            LinearGradient(
                colors: [
                    .black.opacity(startOpacity),
                    .black.opacity(endOpacity)
                        ],
                startPoint: edge.off,
                endPoint: isEffectActive ? edge.onQuarter : edge.off
            )
        }
        
//        .frame(
//            width: abs(edge.axis == .horizontal ? length : .infinity),
//            height: abs(edge.axis == .vertical ? length : .infinity)
//        )
        
        .frame(
            maxWidth: abs(edge.axis == .horizontal ? length : .infinity),
            maxHeight: abs(edge.axis == .vertical ? length : .infinity),
            alignment: edge.alignment
        )
        .padding(Edge.Set(edge), offset)
        
        
    }
}

extension ScrollMask {
    
    var startOpacity: Double {
        switch maskMode {
        case .mask:
            /// Starting at fully transparent means the content will be completely
            /// faded out at the top, and fade in as it goes down
            return isEffectActive ? 0.0 : 1.0
        case .overlay:
            /// This is the opposite
            return isEffectActive ? opacity : 0.0
            
        }
    }

    var endOpacity: Double {
        switch maskMode {
        case .mask:
            return 1.0
        case .overlay:
            return 0.0
        }
    }

}

public extension View {
    func scrollMask(
        _ isEffectActive: Bool,
        maskMode: MaskMode = .mask,
        edge: Edge = .top,
        opacity: Double = 0.2,
        length: CGFloat = 130,
        offset: CGFloat = .zero
    ) -> some View {
        self.modifier(
            ScrollMask(
                isEffectActive: isEffectActive,
                maskMode: maskMode,
                edge: edge,
                opacity: opacity,
                length: length,
                offset: offset
            )
        )
    }
}
