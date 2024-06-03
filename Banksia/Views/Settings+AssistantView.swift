//
//  Settings+AssistantView.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import Form
import Icons
import TextEditor
import MarkdownEditor
import Swatches
import ComponentBase
import GeneralStyles

struct Settings_AssistantView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    
    @EnvironmentObject var pref: Preferences
    
    @FocusState private var isEditorFocused
    
    var swatches: [Swatch] = [
        .aqua, .chalkBlue, .lavendar, .peach, .olive
    ]
    
    
    var body: some View {
        
        @Bindable var bk = bk
        
        
        CustomSection(label: "Interface") {
            
            // MARK: - UI Dimming
            LabeledContent {
                Text("\(bk.uiDimming * 100, specifier: "%.0f")%")
                    .monospacedDigit()
                Slider(
                    value: $bk.uiDimming,
                    in: 0.01...0.89,
                    onEditingChanged: { changed in
                        if changed {
                            pref.uiDimming = bk.uiDimming
                        }
                    }
                )
                .tint(pref.accentColour.colour)
                .controlSize(.mini)
                //                            .tint(Swatch.lightGrey.colour)
                .frame(
                    minWidth: 80,
                    maxWidth: 140
                )
            } label: {
                Label("UI Dimming", systemImage: Icons.contrast.icon)
            }
            
            
            
            LabeledContent {
                HStack(spacing: 12) {
                    
                    let swatchSize: Double = 28
                    
                    ForEach(swatches) { swatch in
                        Button {
                            withAnimation(Styles.animation) {
                                pref.accentColour = swatch
                            }
                        } label: {
                            RimLightShape(colour: AnyShapeStyle(swatch.colour)) {
                                Circle()
                            }
                            .frame(width: swatchSize, height: swatchSize)
                            .offset(y: pref.accentColour == swatch ? -6 : 0)
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
                    
                    //                                ForEach(swatches, id: \.id) { swatch in
                    //                                    RimLightShape(colour: AnyShapeStyle(swatch.colour)) {
                    //                                        Circle()
                    //                                    }
                    //                                    .tag(swatch)
                    //                                    .frame(width: swatchSize, height: swatchSize)
                    //                                }
                }
            } label: {
                Label("Accent colour", systemImage: Icons.palette.icon)
                Text("Changes the colour of message bubbles, code, and other UI elements.")
                    .caption()
            }
            .labeledContentStyle(.customLabeledContent(labelAlignment: .top))
            
            
            
        } // END interface section
        
        
        
        // MARK: - Grainient
        // TODO: Hiding the below for now, as i'm not sure a 'default grainient' is actually going to be enough of a thing
        //                    LabeledContent {
        //                        GrainientPicker(
        //                            seed: $bk.defaultGrainientSeed,
        //                            popup: popup,
        //                            viewSeedEnabled: false
        //                        )
        //                    } label: {
        //                        Label("Default background", systemImage: Icons.gradient.icon)
        //                        Text("Customise the gradient background that appears when no conversation is selected.")
        //                    }
        //
        //                    GrainientPreviews(seed: $bk.defaultGrainientSeed)
        
        
        
        Section("Customise AI") {
            
            
            
            
            LabeledContent {
                Text("\(pref.gptTemperature, specifier: "%.1f")")
                    .monospacedDigit()
                
                Slider(
                    value: $pref.gptTemperature,
                    in: 0.0...1.0,
                    step: 0.1
                )
                .frame(
                    minWidth: 80,
                    maxWidth: 140
                )
            } label: {
                Label("GPT Temperature", systemImage: Icons.snowflake.icon)
            }
            
            LabeledContent {
                
                Button {
                    bk.isEditingLongFormText.toggle()
                } label: {
                    Label("Edit", systemImage: Icons.edit.icon)
                }
                .buttonStyle(.customButton(size: .small))
                
            } label: {
                
                Label("System-wide prompt", systemImage: Icons.text.icon)
                Text("This will be included for each message in each conversation.")
            }
            
            Text(pref.systemPrompt)
                .multilineTextAlignment(.leading)
                .lineLimit(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
                .sheet(isPresented: $bk.isEditingLongFormText) {
                    
                    TextEditorView(
                        text: $pref.systemPrompt,
                        isPresented: $bk.isEditingLongFormText) { text in
                            MarkdownEditorView(
                                text: text,
                                placeholderText: "Enter system prompt",
                                isFocused: $isEditorFocused
                            )
                            .focused($isEditorFocused)
                        }
                }
        }
    }
}

#Preview {
    Settings_AssistantView()
        .environment(BanksiaHandler())
}
