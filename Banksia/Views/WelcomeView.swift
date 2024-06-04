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
import Easing

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var pref: Preferences
    
    @State private var welcomeGrainientSeed: Int = 68935
    
    let elementHeight: Double = 30
    
    @State private var isHovering: Bool = false
    
    @State private var rotationFactor: CGFloat = 0.0
    @State private var rotationAngle: Double = 0.0
    
    // Adjustable parameters
    let maxRotation: Double = 15.0
    let duration: Double = 2.0
    let wiggleFrequency: Double = 10.0
    let easing: EasingType = .easeInOut
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Group {
                Text("Welcome to ").foregroundStyle(.secondary) + Text("Banksia")
            }
            .font(.custom(OstiaFont.bookItalic.font, size: 46))
            
            
            VStack(spacing: 20) {
                Rectangle()
                    .fill(Swatch.grey.colour)
                    .frame(height: elementHeight + 6)
                    .offset(y: -2)
                    .rotationEffect(.degrees(-0.3))
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
                    HStack(spacing: 30) {
                        
                        Text("🔒")
                            .font(.system(size: 48))
                            .rotationEffect(.degrees(-2.6))
                        
                        RoundedRectangle(cornerRadius: Styles.roundingMedium)
                            .fill(Swatch.offWhite.colour)
                            .frame(height: elementHeight)
                            .rotationEffect(.degrees(0.2))
                        
                    }
                    
                    Spacer()
                    
                    HStack{
                        FakeButton("Always Allow", colour: Swatch.olive.colour, angle: -0.8)
                            .rotationEffect(.degrees(rotationAngle))
                            .onAppear {
                                withAnimation(
                                    Animation.linear(duration: duration)
                                        .repeatForever(autoreverses: false)
                                ) {
                                    self.rotationFactor = 1.0
                                }
                            }
                            .onChange(of: rotationFactor) {
                                let easedValue = applyEasing(rotationFactor, easing: easing)
                                let wiggleValue = sin(rotationFactor * .pi * wiggleFrequency)
                                self.rotationAngle = easedValue * maxRotation * wiggleValue
                            }
                        
                        
                        
                        
                        
                        
                        Spacer()
                        FakeButton("", colour: Swatch.offWhite.colour, angle: 0.4)
                        
                    }
                    
                }
                .padding(.horizontal, Styles.paddingGenerous)
                .padding(.bottom, Styles.paddingGenerous)
            } // END vstack
            .aspectRatio(2.1, contentMode: .fit)
            .frame(width: 400)
            .background(Swatch.lightGrey.colour)
            .clipShape(.rect(cornerRadius: Styles.roundingHuge))
            .basicShadow(opacity: 0.8, radius: 14, distanceY: 30)
            .padding(.bottom, 40)
            
            
            
            let byo = Text("BYO API Key").fontWeight(.bold).foregroundStyle(.primary)
            
            Group {
                Text("Banksia is ") + byo + Text(" other stuff")
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 15, weight: .medium))
            
            
            Spacer()
            
            //                .overlay {
            GrainientPicker(seed: $welcomeGrainientSeed)
            //                        .padding(.top, 60)
            //                }
            
            HStack(alignment: .bottom, spacing: 20) {
                
                Button {
                    
                } label: {
                    Label("I 􀊵 gradients", systemImage: Icons.text.icon)
                }
                .buttonStyle(.customButton(size: .small, labelDisplay: .titleOnly))
                .opacity(isHovering ? 1.0 : 0.3)
                .hoverAsync { hovering in
                    isHovering = hovering
                }
                
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

extension WelcomeView {
    @ViewBuilder
    func FakeButton(
        _ text: String,
        colour: Color,
        angle: Double
    ) -> some View {
        Text(text)
            .foregroundStyle(.primary)
            .fontWeight(.semibold)
            .frame(width: 140, height: elementHeight)
            .background(colour)
            .clipShape(.rect(cornerRadius: Styles.roundingMedium))
        //            .rotationEffect(.degrees(angle))
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Preferences())
        .frame(width: 600, height: 700)
}


