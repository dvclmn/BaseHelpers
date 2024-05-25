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
import Styles
import GeneralUtilities
import Form

@MainActor
struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    
    @Environment(BanksiaHandler.self) private var bk
    
    @State private var apiKey: String = ""
    
    @State private var isShowingSecureInformation: Bool = false
    @State private var isConnectedToOpenAI: Bool = false
    @State private var isLoadingConnection: Bool = false
    
    @State private var isEditingLongFormText: Bool = false
    
    let apiKeyString: String = "openAIAPIKey"
    
    var body: some View {
        
        
        @Bindable var bk = bk
        
            Form {
                
                Section("Interface") {
                    LabeledContent {
                        HStack {
                            Text("\(pref.uiDimming * 100, specifier: "%.0f")%")
                                .monospacedDigit()
                            Slider(
                                value: $pref.uiDimming,
                                in: 0.01...0.89)
                                .controlSize(.mini)
                                .tint(Swatch.lightGrey.colour)
                                .frame(
                                    minWidth: 60,
                                    maxWidth: 90
                                )
                        }
                    } label: {
                        Text("Interface dimming")
                    }
                }
                
                
                
                Section("API") {
                    LabeledContent {
                        HStack {
                            if isShowingSecureInformation {
                                TextField("API Key", text: $apiKey, prompt: Text("Enter API Key"))
                                    .onSubmit {
                                        Task {
                                            await submitAPIKey()
                                        }
                                    }
                            } else {
                                SecureField("API Key", text: $apiKey, prompt: Text("Enter API Key"))
                                
                                    .onSubmit {
                                        Task {
                                            await submitAPIKey()
                                        }
                                    }
                            }
                            Button {
                                isShowingSecureInformation.toggle()
                            } label: {
                                Label(isShowingSecureInformation ? "Hide key" : "Show key", systemImage: Icons.eye.icon)
                            }
                            .buttonStyle(.customButton(size: .mini, status: isShowingSecureInformation ? .active : .normal, hasBackground: false, labelDisplay: .iconOnly))
                        } // END group
                        .labelsHidden()
                    } label: {
                        HStack {
                            Text("API Key")
                            
                        }
                        .padding(.bottom, 6)
                        
                        if !apiKey.isEmpty {
                            HStack(spacing: 0) {
                                Text("Status: \(isConnectedToOpenAI ? "Connected" : "No connection")")
                                if isLoadingConnection {
                                    Image(systemName: Icons.rays.icon)
                                        .spinning()
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    
                    
                    LabeledContent {
                        Picker("Select model", selection: $pref.gptModel) {
                            ForEach(AIModel.allCases, id: \.self) { model in
                                Text(model.name).tag(model.value)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    } label: {
                        Text("Select model")
                            .padding(.bottom, 6)
                        VStack(alignment: .leading) {
                            Text("Current:\t\t\t**\(pref.gptModel.name)**")
                            Text("Context window:\t**\(pref.gptModel.contextWindow) tokens**")
                            Text("Training cut-off:\t**\(pref.gptModel.trainingCutoff)**")
//                            Text("[More information](\(pref.gptModel.infoURL)) 􀄯")
                        }
                        
                        
                    }
                    
                    LabeledContent {
                        
                        Slider(
                            value: $pref.gptTemperature,
                            in: 0.0...1.0,
                            step: 0.1
                        )
                    } label: {
                        Text("GPT temperature")
                    }
                    
                    
                    
                    
                    
                    FormLabel(label: "Name", icon: Icons.title.icon, message: "If you are comfortable doing so, provide your name here to personalise your assistants response.") {
                        TextField("", text: pref.$userName.boundString, prompt: Text("Enter your name"))
                            
                    }
                    
                    FormLabel(label: "System-wide prompt", icon: Icons.text.icon, message: "This will be included for each message in each conversation.") {
                        
                        VStack(alignment: .leading, spacing: 14) {
                            TextField("", text: pref.$systemPrompt, prompt: Text("System prompt"), axis: .vertical)
                                .multilineTextAlignment(.leading)
                                .lineLimit(4)
                            if !pref.systemPrompt.isEmpty {
                                Button {
                                    isEditingLongFormText.toggle()
                                } label: {
                                    Label("Expand", systemImage: Icons.expand.icon)
                                }
                                .buttonStyle(.customButton())

                            }
                        }
                        .padding(.top, 8)
                        
                    }
                    .onAppear {
                        if isPreview {
                            pref.systemPrompt = Message.prompt_01.content
                        }
                    }
                    .sheet(isPresented: $isEditingLongFormText) {
                        TextEditor(text: pref.$systemPrompt)
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            } // END form
            .scrollContentBackground(.hidden)
            .formStyle(.grouped)
            .safeAreaPadding(.top, isPreview ? 0 :Styles.toolbarHeight)

            .grainient(seed: 86206, dimming: $pref.uiDimming)
//        .task(id: apiKey) {
//            isConnectedToOpenAI = await verifyOpenAIConnection()
//        }
        
    }
}

extension SettingsView {
    
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

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SettingsView()
            .padding(.top,1)
    }
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .frame(width: 480, height: 500)

}

