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
    
    @State private var settingsTab: SettingsTab = .interface
    
    var body: some View {
        
        
        VStack {
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
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .padding(.bottom, 4)
            .background(.thinMaterial)
            
            Form {
                
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
                                .lineLimit(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } content: {
                            
                            Button {
                                bk.isEditingLongFormText.toggle()
                            } label: {
                                Label("Edit", systemImage: Icons.edit.icon)
                            }
                            //                    .buttonStyle(.customButton(size: .small, hasBackground: false))
                            
                        }
                    }
                case .connections:
                    Settings_ConnectionView()
                case .shortcuts:
                    Settings_ShortcutsView()
                }
                
            } // END form
            .scrollContentBackground(.hidden)
            .formStyle(.grouped)
        }
        .frame(
            minWidth: 380,
            idealWidth: 500,
            maxWidth: 780,
            minHeight: 280,
            idealHeight: 600,
            maxHeight: .infinity
        )
        .safeAreaPadding(.top, isPreview ? 0 :Styles.toolbarHeight)
        .scrollIndicators(.hidden)
        .grainient(seed: pref.defaultGrainientSeed, dimming: $pref.uiDimming)
        .ignoresSafeArea()
        
    }
}

extension SettingsView {
    
    // TODO: The system asking for mac login password felt too invaisve, for not enough benefit
    //    private func authenticate() {
    //        let context = LAContext()
    //        var error: NSError?
    //
    //        // check whether biometric authentication is possible
    //        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
    //
    //
    //            /// Application reason for authentication. This string must be provided in correct localization and should be short and clear. It will be eventually displayed in the authentication dialog as a part of the following string: "<appname>" is trying to <localized reason>.
    //            /// For example, if the app name is "TestApp" and localizedReason is passed "access the hidden records", then the authentication prompt will read: "TestApp" is trying to access the hidden records.
    //            let reason = "reveal your API Key"
    //
    //            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
    //                // authentication has now completed
    //                if success {
    //                    isKeyUnlocked = true
    //                } else {
    //                    popup.showPopup(title: "Error displaying API key", message: "Please try authenticating again.")
    //                }
    //            }
    //        } else {
    //            // no biometrics
    //        }
    //    }
    
    
    
    
    
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
    .frame(width: 480, height: 600)
    
}

#endif
