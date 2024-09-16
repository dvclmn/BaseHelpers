//
//  File.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation
import SwiftUI

struct ScaleEffectForShadow: GeometryEffect {
    var scale: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        return ProjectionTransform(scaleTransform)
    }
}

public struct ShadowModifier: ViewModifier {
    
    var opacity: Double
    var radius: Double
    var distanceY: Double
    var distanceZ: Double
    
    public func body(content: Content) -> some View {
        
        var depth: Double {
            return min(1.0, max(0.0, distanceZ))
        }
        
        
        content
        
            .background {
                content
                    .scaleEffect(depth)
                    .shadow(color: .black.opacity(opacity), radius: radius / 2, x: 0, y: 1)
                    .shadow(color: .black.opacity(opacity), radius: radius * 2, x: 0, y: distanceY)
            }

    }
    
}


public extension View {
    func customShadow(
        opacity: Double = 0.2,
        radius: Double = 4,
        distanceY: Double = 6,
        distanceZ: Double = 0.9
    ) -> some View {
        self.modifier(ShadowModifier(
            opacity: opacity,
            radius: radius,
            distanceY: distanceY,
            distanceZ: distanceZ
        ))
    }
}



private struct ShadowExampleView: View {
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            VStack {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 34)
                    .overlay(alignment: .leading) {
                        HStack(spacing: 8) {
                            ForEach(1...3, id: \.self) { circle in
                                Circle()
                                    .frame(width: 14)
                                    .opacity(0.2)
                            }
                        } // END hstack
                        .padding(.leading, 14)
                    } // END circles overlay
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 30)
                        .padding(.leading, 50)
                        .opacity(0.7)
                    
                    
                    Spacer()
                    
                    Text("Always Allow")
                        .foregroundStyle(.primary)
                        .fontWeight(.semibold)
                        .frame(width: 140, height: 30)
                        .background(.teal)
                        .clipShape(.rect(cornerRadius: 10))
                        .rotationEffect(.degrees(-1))
                    
                }
                .padding(38)
            } // END vstack
            .aspectRatio(2.1, contentMode: .fit)
            .frame(width: 400)
            .background(.gray)
            .clipShape(.rect(cornerRadius: 20))
            .customShadow(opacity: 0.7, radius: 16, distanceY: 50)
            .padding(.bottom, 40)
            
            
            
            let byo = Text("BYO API Key").fontWeight(.bold).foregroundStyle(.primary)
            
            Group {
                Text("Banksia is ") + byo + Text(" other stuff")
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 15, weight: .medium))
            
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .padding(38)
        .background(.teal)
        
    }
}

#Preview {
    ShadowExampleView()
        .frame(width: 600, height: 700)
}





