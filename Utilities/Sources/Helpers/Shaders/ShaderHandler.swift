//
//  ShaderHandler.swift
//  Eucalypt
//
//  Created by Dave Coleman on 23/2/2024.
//

import Foundation
import SwiftUI

struct WavyBlur: ViewModifier {
    private let startDate = Date()
    func body(content: Content) -> some View {
        content
            .overlay {
                TimelineView(.animation) { _ in
                    Rectangle()
                        .colorEffect(ShaderLibrary.psychodelics(
                            .boundingRect,
                            .float(startDate.timeIntervalSinceNow)
                        ))
                        .scaleEffect(10)
//                        .drawingGroup()
                    
                }
//                .blur(radius: 6, opaque: true)
                .brightness(-0.30)
                .blendMode(.colorDodge)
                .hueRotation(Angle(degrees: 90))
                .opacity(0.2)
                .saturation(0.7)
                .allowsHitTesting(false)
            }   // END overlay
    }
}

extension View {
    func wavyBlur() -> some View {
        modifier(WavyBlur())
    }
}

struct Glitter: ViewModifier {
    private let startDate = Date()
    @State private var oscillatingValue: CGFloat = -1.0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    ZStack {
                        Color.blue
                        TimelineView(.animation) { _ in
//                            Image(.rgbaNoise)
//                                .resizable(resizingMode: .tile)
//                                .rotation3DEffect(.degrees(20 * oscillatingValue), axis: (x: 6 * oscillatingValue, y: 4 * oscillatingValue, z: 0))
//        //                        .frame(width: 400, height: 600)
//                                .scaledToFill()
//                                .scaleEffect(3)
//                                .offset(x: 10 * oscillatingValue, y: 14 * oscillatingValue)
//                                .visualEffect { content, geo in
//                                    content
//                                        .layerEffect(ShaderLibrary.glitterTest(
//                                            .float2(geo.size),
//                                            .float(startDate.timeIntervalSinceNow)), maxSampleOffset: .zero)
//                                        
//                                }
                                
                                
                        } // END timeline
                        .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                } // END vstack
                .blur(radius: 1.0)
                .blendMode(.colorDodge)
                .opacity(0.2)
                

                
                
            } // END overlay
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    oscillatingValue = 1.0
                }
            } // END on appear
        
        
        
        //                        .overlay {
        //                            VStack {
        //                                LinearGradient(stops: [
        //                                    .init(color: .clear, location: 0),
        //                                    .init(color: .white, location: 0.4),
        //                                    .init(color: .clear, location: 0.45),
        //                                    .init(color: .white, location: 0.75),
        //                                    .init(color: .clear, location: 1.0)
        //                                ], startPoint: .leading, endPoint: .trailing)
        //                            }
        //                            .frame(width: 700, height: 6000)
        //                            .rotationEffect(.degrees(45))
        //                            .offset(x: 800 * whipAnimation)
        //                            .blendMode(.overlay)
        //                            .opacity(0.1)
        //                        }
        //
        //
        //
        //
        //
        
    }
}

extension View {
    func glitter() -> some View {
        modifier(Glitter())
    }
}




struct ChromaticAbberation: ViewModifier {

    let chromaticSplit: Float = 0.6
    
    func body(content: Content) -> some View {
        content
            .layerEffect(ShaderLibrary.chromatic_abberation_static(
                .float(chromaticSplit),
                .float(chromaticSplit),
                .float(0.6)
            ), maxSampleOffset: .zero)

    }
}

extension View {
    func chromaticAbberation() -> some View {
        modifier(ChromaticAbberation())
    }
}

