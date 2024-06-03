//
//  SwatchButtonView.swift
//  Banksia
//
//  Created by Dave Coleman on 3/6/2024.
//

import SwiftUI
import GeneralStyles
import Swatches
import ComponentBase

struct SwatchButtonView: View {
    @EnvironmentObject var pref: Preferences
    
    var swatch: Swatch
    
    @State private var isHovering: Bool = false
    
    let swatchSize: Double = 28
    
    var body: some View {
        Button {
            withAnimation(Styles.animationSpringSubtle) {
                pref.accentColour = swatch
            }
        } label: {
            RimLightShape(colour: AnyShapeStyle(swatch.colour)) {
                Circle()
            }
            .frame(width: swatchSize, height: swatchSize)
            .offset(y: pref.accentColour == swatch ? -4 : 0)
            .opacity(pref.accentColour == swatch || isHovering ? 1.0 : 0.65)
            .onHover { hovering in
                withAnimation(Styles.animationQuick) {
                    isHovering = hovering
                }
            }
//                            .overlay {
//                                Circle()
//                                    .stroke(pref.accentColour == swatch ? Color.secondary : Color.clear, lineWidth: 2)
//                            }
//                            .overlay(alignment: .bottom) {
//                                if pref.accentColour == swatch {
                    
                    //                                    Circle()
                    //                                        .fill(.secondary)
                    //                                        .offset(y: swatchSize * 0.5)
                    //                                        .frame(width: 7)
//                                }
//                            }
        } // END button
        .buttonStyle(.plain)
    }
}

#Preview {
    SwatchButtonView(swatch: Swatch.aqua)
}
