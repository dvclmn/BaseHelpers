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

@MainActor
struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    
    @Environment(BanksiaHandler.self) private var bk
    
    @State private var apiKey: String = ""
    
    @State private var isConnectedToOpenAI: Bool = false
    @State private var isLoadingConnection: Bool = false
    
    @State private var isKeyUnlocked = false

    @FocusState private var isFocused
    
    @State private var isEditingLongFormText: Bool = false
    
    let apiKeyString: String = "openAIAPIKey"
    
    var body: some View {
        
        
        @Bindable var bk = bk
        
        Form {
            
            Section("Interface") {
                
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
                    
//                    Button {
//                        pref.defaultGrainientSeed = GrainientSettings.generateGradientSeed()
//                    } label: {
//                        Label("Generate", systemImage: Icons.refresh.icon)
//                    }
                }

            }
            
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
                        isEditingLongFormText.toggle()
                    } label: {
                        Label("Edit", systemImage: Icons.edit.icon)
                    }
//                    .buttonStyle(.customButton(size: .small, hasBackground: false))
                    
                }
            }
            
            
            
            Section("Connection") {
                
                FormLabel(
                    label: "API Key",
                    icon: Icons.key.icon
                ) {
                    if !apiKey.isEmpty {
                        HStack(spacing: 0) {
                            Text("Status: **\(isConnectedToOpenAI ? "Connected" : "No connection")**")
                            if isLoadingConnection {
                                Image(systemName: Icons.rays.icon)
                                    .spinning()
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                } content: {
                    HStack {
                        if isKeyUnlocked {
                            TextField("API Key", text: $apiKey, prompt: Text("Enter API Key"))
                                .onSubmit {
                                    Task {
                                        await submitAPIKey()
                                    }
                                }
                        } else {
                            SecureField("API Key", text: $apiKey, prompt: Text("Enter API Key"))
                                .foregroundStyle(.secondary)
                                .onSubmit {
                                    Task {
                                        await submitAPIKey()
                                    }
                                }
                        }
                        Button {
                            isKeyUnlocked.toggle()
                        } label: {
                            Label(isKeyUnlocked ? "Hide key" : "Show key", systemImage: Icons.eye.icon)
                        }
                        .buttonStyle(.customButton(size: .mini, status: isKeyUnlocked ? .active : .normal, hasBackground: false, labelDisplay: .iconOnly))
                        .onAppear {
                            Task {
                                if let key = KeychainHandler.shared.readString(for: apiKeyString) {
                                    apiKey = key
                                    isConnectedToOpenAI = await verifyOpenAIConnection()
                                }
                            }
                        } // END on appear
                        
                    } // END group
                    .labelsHidden()
                }
                
                
                
                
                
                
                
                
                FormLabel(
                    label: "Select model",
                    icon: Icons.shocked.icon) {
                        Text("Current:\t\t\t**\(pref.gptModel.name)**")
                        Text("Context length:\t**\(pref.gptModel.contextLength) tokens**")
                        Text("Training cut-off:\t**\(pref.gptModel.cutoff)**")
                    } content: {
                        Picker("Select model", selection: $pref.gptModel) {
                            ForEach(GPTModel.allCases, id: \.self) { model in
                                Text(model.name).tag(model.model)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                    
                
                
                
                
//                    .onAppear {
//                        if isPreview {
//                            pref.systemPrompt = Message.prompt_01.content
//                        }
//                    }
                    .sheet(isPresented: $isEditingLongFormText) {
//                        TextEditor(text: pref.$systemPrompt)
                        
                        TextEditorView(
                            text: pref.$systemPrompt,
                            isPresented: $isEditingLongFormText) { text in
                                MarkdownEditorView(
                                    text: text,
                                    placeholderText: "Enter system prompt",
                                    isFocused: $isFocused
                                )
                                .focused($isFocused)
                            }
                    }
                
            } // End connection section

        } // END form
        .frame(
            minWidth: 380,
            idealWidth: 500,
            maxWidth: 780,
            minHeight: 280,
            idealHeight: 600,
            maxHeight: .infinity
        )
        .scrollContentBackground(.hidden)
        .formStyle(.grouped)
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
    
    
    
    
    private func verifyOpenAIConnection() async -> Bool {
        
        isLoadingConnection = true
        
        guard let key = KeychainHandler.shared.readString(for: apiKeyString) else {
            print("Could not get key from keychain")
            isLoadingConnection = false
            return false
        }
        
        let url: String = "https://api.openai.com/v1/models"
        
        do {
            let result: TestResponse = try await APIHandler.constructRequestAndFetch(
                url: URL(string: url),
                requestType: .get,
                bearerToken: key
            )
            print("Data from OpenAI: \(result)")
            
            isLoadingConnection = false
            return true
            
        } catch {
            isLoadingConnection = false
            return false
        }
        
    }
    
    private func submitAPIKey() async {
        do {
            try KeychainHandler.shared.save(self.apiKey, for: apiKeyString)
            self.isConnectedToOpenAI = await verifyOpenAIConnection()
        } catch {
            popup.showPopup(title: "Issue saving API Key", message: "Please try again.")
        }
    }
}




#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SettingsView()
            .padding(.top,1)
    }
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .environmentObject(PopupHandler())
    .frame(width: 480, height: 600)
    
}

#endif
