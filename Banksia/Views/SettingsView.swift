//
//  SettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI
import SwiftData
import Grainient
import Swatches
import KeychainHandler
import Popup
import Icons
import Button
import APIHandler
import GeneralStyles
import GeneralUtilities
import Form
import TextEditor
import MarkdownEditor
import GrainientPicker
import Sidebar

enum SettingsTab: CaseIterable {
    case interface
    case assistant
    case connections
    case shortcuts
    
    var name: String {
        switch self {
        case .interface:
            "Interface"
        case .assistant:
            "Assistant"
        case .connections:
            "Connections"
        case .shortcuts:
            "Shortcuts"
        }
    }
    
    var icon: String {
        switch self {
        case .interface:
            Icons.gear.icon
        case .assistant:
            Icons.shocked.icon
        case .connections:
            Icons.plug.icon
        case .shortcuts:
            Icons.command.icon
        }
    }
}

@MainActor
struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @State private var settingsTab: SettingsTab = .interface
    
    @FocusState private var isEditorFocused
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                ForEach(SettingsTab.allCases, id: \.name) { tab in
                    Button {
                        settingsTab = tab
                    } label: {
                        Label(tab.name, systemImage: tab.icon)
                    }
                    .buttonStyle(.customButton(
                        size: .huge,
                        status: settingsTab == tab ? .active : .normal,
                        hasBackground: false,
                        labelDisplay: .stacked
                    ))
                    .symbolVariant(.fill)
                }
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 70,
                maxHeight: 70
            )
            .background(.ultraThinMaterial)
            
            CustomForm {
                
                switch settingsTab {
                    
                case .interface:
                    
                    FormLabel(
                        label: "Name",
                        icon: Icons.person.icon,
                        message: "(Optional) Provide your name to personalise responses."
                    ) {
                        TextField("", text: pref.$userName.boundString, prompt: Text("Enter your name"))
                    }
                    
                    FormLabel(label: "UI Dimming", icon: Icons.contrast.icon) {
                        Text("\(pref.uiDimming * 100, specifier: "%.0f")%")
                            .monospacedDigit()
                        Slider(
                            value: $pref.uiDimming,
                            in: 0.01...0.89)
                        .controlSize(.mini)
                        .tint(Swatch.lightGrey.colour)
                        .frame(
                            minWidth: 80,
                            maxWidth: 140
                        )
                    }
                    
                    FormLabel(
                        label: "Default background",
                        icon: Icons.gradient.icon,
                        message: "Customise the gradient background that appears when no conversation is selected."
                    ) {
                        GrainientPicker(
                            seed: $pref.defaultGrainientSeed,
                            popup: popup,
                            viewSeedEnabled: false
                        )
                        
                    }
                    
                    GrainientPreviews(seed: $pref.defaultGrainientSeed)
                    

                case .assistant:
                    
                    Section("Customise AI") {
                        FormLabel(
                            label: "GPT Temperature",
                            icon: Icons.snowflake.icon) {
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
                            }
                        
                        
                        FormLabel(
                            label: "System-wide prompt",
                            icon: Icons.text.icon,
                            message: "This will be included for each message in each conversation."
                        ) {
                            Text(pref.systemPrompt)
                                .multilineTextAlignment(.leading)
                                .lineLimit(6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } content: {
                            
                            Button {
                                bk.isEditingLongFormText.toggle()
                            } label: {
                                Label("Edit", systemImage: Icons.edit.icon)
                            }
                            .buttonStyle(.customButton(size: .small))
                            
                        }
                        .sheet(isPresented: $bk.isEditingLongFormText) {

                            TextEditorView(
                                text: pref.$systemPrompt,
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
                case .connections:
                    Settings_ConnectionView()
                case .shortcuts:
                    Settings_ShortcutsView()
                }
                
            } // END form
            .background(Swatch.slate.colour.opacity(0.6))
            .background(.ultraThickMaterial)
            

        } // END main vstack
        .frame(
            minWidth: 380,
            idealWidth: 500,
            maxWidth: 780,
            minHeight: 280,
            idealHeight: 600,
            maxHeight: .infinity
        )
        .grainient(seed: pref.defaultGrainientSeed, version: .v1)
        .onAppear {
            if isPreview {
                settingsTab = .interface
            }
        }
        
    }
}


#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SettingsView()
            .padding(.top,1)
    }
    .environmentObject(BanksiaHandler())
    .environmentObject(Preferences())
    .environmentObject(PopupHandler())
    .environmentObject(SidebarHandler())
    .frame(width: 480, height: 600)
    
}

#endif



public struct CustomForm<Content: View>: View {
    
    let content: Content
    
    public init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                content
            }
            .padding(Styles.paddingGenerous)
        }
        .scrollIndicators(.hidden)
        
    }
}


