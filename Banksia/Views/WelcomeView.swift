//
//  WelcomeView.swift
//  Banksia
//
//  Created by Dave Coleman on 4/6/2024.
//

import SwiftUI
import Grainient
import GrainientPicker
import Icons
import GeneralStyles
import Swatches

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var pref: Preferences
    
    @State private var welcomeGrainientSeed: Int = 68935
    
    
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Welcome to Banksia")
            
            Rectangle()
                .fill(Swatch.lightGrey.colour)
                .aspectRatio(2.1, contentMode: .fit)
                .frame(width: 400)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Swatch.grey.colour)
                        .frame(height: 36)
                        .overlay(alignment: .leading) {
                            HStack(spacing: 8) {
                                ForEach(1...3, id: \.self) { circle in
                                    
                                    var circleColour: Swatch {
                                        if circle == 1 {
                                            return Swatch.olive
                                        } else if circle == 2 {
                                            return Swatch.lightGrey
                                        } else {
                                            return Swatch.eggplant
                                        }
                                    }
                                    Circle()
                                        .fill(circleColour.colour)
                                        .frame(width: 14)
                                }
                            } // END hstack
                            .padding(.leading, 14)
                        }
                }
                .clipShape(.rect(cornerRadius: Styles.roundingHuge))
            
                .font(.custom(OstiaFont.bookItalic.font, size: 46))
            
            Spacer()
                
//                .overlay {
//                    GrainientPicker(seed: $welcomeGrainientSeed)
//                        .padding(.top, 60)
//                }
            
            HStack(spacing: 20) {
                Spacer()
                
                Toggle(isOn: $pref.isWelcomeScreenEnabled) {
                    Label("Don't show again", systemImage: Icons.command.icon)
                        .labelStyle(.customLabel(labelDisplay: .titleOnly))
                }
                .controlSize(.small)
                .toggleStyle(.switch)
                .tint(pref.accentColour.colour)
                
                Button {
                    dismiss()
                } label: {
                    Label("Get started", systemImage: Icons.text.icon)
                }
                .buttonStyle(.customButton(labelDisplay: .titleOnly))
                
            }
        } // END vstack
        .padding(Styles.paddingGenerous)
        .sheetFrame()
        .grainient(seed: welcomeGrainientSeed, version: .v3)
        
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Preferences())
    .frame(width: 600, height: 700)
}
