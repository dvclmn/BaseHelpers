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
import GeneralUtilities

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var pref: Preferences
    
    @State private var welcomeGrainientSeed: Int = 68935
    
    let elementHeight: Double = 30
    
    @State private var isHovering: Bool = false
    
    @State private var isUserDismissingWelcomeScreen: Bool = true
    
    let minWidth: Double = 460
    let maxWidth: Double = 600
    
    @State private var testWidth: Double = 480
    
    let paddingBase: Double = 40
    
    var body: some View {
        
        VStack(spacing: 42) {
            
            
            HStack {
                Text("Welcome to ").foregroundStyle(.secondary) + Text("Banksia")
            }
            .font(.custom(OstiaFont.bookItalic.font, size: 46))
            .fixedSize(horizontal: false, vertical: true)
            //                .padding(.bottom, 14)
            
            // MARK: - Dialogue box
            VStack(spacing: 18) {
                
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
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 30) {
                        Text("🔒")
                            .font(.system(size: 48))
                            .rotationEffect(.degrees(-2.6))
                            .opacity(0.9)
                        
                        /// White textfield
                        RoundedRectangle(cornerRadius: Styles.roundingMedium)
                            .fill(Swatch.offWhite.colour)
                            .frame(height: elementHeight)
                            .rotationEffect(.degrees(0.2))
                        
                    }
                    
                    
                    
                    HStack(spacing: 22) {
                        FakeButton("Always Allow", colour: Swatch.olive.colour, angle: -0.8)
                        
                        Spacer()
                        FakeButton("", colour: Swatch.offWhite.colour, angle: 0.4)
                        
                    }
                    
                } // END guts of dialogue vstack
                .padding(.horizontal, Styles.paddingGenerous)
                .padding(.bottom, Styles.paddingGenerous)
            } // END vstack
            .frame(maxWidth: 480)
            .background(Swatch.lightGrey.colour)
            .clipShape(.rect(cornerRadius: Styles.roundingHuge))
            .basicShadow(opacity: 0.7, radius: 16, distanceY: 24)
            
            
            let byo = Text("BYO API Key").fontWeight(.semibold).foregroundStyle(.primary)
            let alwaysAllow = Text("Always Allow").fontWeight(.semibold).foregroundStyle(.primary)
            
            HStack {
                Text("Banksia is a ") + byo + Text(" app. Your data is stored securely in the macOS Keychain, which will usually prompt a dialogue like the above. Click ") + alwaysAllow + Text(" to prevent seeing this message on each startup.")
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 14, weight: .medium))
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: Styles.readingWidthDialogue)
            .padding(.bottom)
            
            //                .overlay {
            //            GrainientPicker(seed: $welcomeGrainientSeed)
            //                        .padding(.top, 60)
            //                }
            
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                
                //                Button {
                //                    withAnimation(Styles.animationRelaxed) {
                //                        welcomeGrainientSeed = GrainientSettings.generateGradientSeed()
                //                    }
                //                } label: {
                //                    Label("I 􀊵 gradients", systemImage: Icons.text.icon)
                //                }
                //                .buttonStyle(.customButton(size: .small, labelDisplay: .titleOnly))
                //                .opacity(isHovering ? 1.0 : 0.3)
                //                .hoverAsync { hovering in
                //                    isHovering = hovering
                //                }
                
                
                Toggle(isOn: $isUserDismissingWelcomeScreen) {
                    Label("Don't show again", systemImage: Icons.command.icon)
                        .labelStyle(.customLabel(size: .small, labelDisplay: .titleOnly))
                        .opacity(0.8)
                        .lineLimit(1)
                }
                .controlSize(.mini)
                .toggleStyle(.switch)
                .tint(pref.accentColour.colour)
                
                Spacer()
                
                
                SettingsLink {
                    Label("Set up key now…", systemImage: Icons.key.icon)
                }
                .buttonStyle(.customButton(size: .small, status: .active, labelDisplay: .titleOnly))
                
                Button {
                    dismiss()
                } label: {
                    Label("I'll do it later", systemImage: Icons.text.icon)
                }
                .buttonStyle(.customButton(size: .small, labelDisplay: .titleOnly))
                
                
            } // END hstack
            
        } // END vstack
        .padding(.top, paddingBase * 1.4)
        .padding(.horizontal, paddingBase)
        .padding(.bottom, paddingBase * 1.2)
        
        .frame(
            minWidth: minWidth,
            //            maxWidth: isPreview ? testWidth : maxWidth
            maxWidth: maxWidth,
            maxHeight: .infinity
        )
        
        .grainient(seed: welcomeGrainientSeed, version: .v3)
        //        .task(id: isUserDismissingWelcomeScreen) {
        //            if isUserDismissingWelcomeScreen {
        //                pref.isWelcomeScreenEnabled = false
        //            }
        //        }
        //        .onAppear {
        //            withAnimation(Styles.animationLoopSlow) {
        //                testWidth = minWidth
        //            }
        //        }
        .onDisappear {
            // Update the AppStorage property when the view disappears
            pref.isWelcomeScreenEnabled = !isUserDismissingWelcomeScreen
        }
        
        
        
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
            .frame(
                maxWidth: 130,
                minHeight: elementHeight,
                maxHeight: elementHeight
            )
            .background(colour)
            .clipShape(.rect(cornerRadius: Styles.roundingMedium))
                    .rotationEffect(.degrees(angle))
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Preferences())
        .frame(width: 460, height: 700)
}


