//
//  Settings+ConnectionView.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import Form
import Icons
import KeychainHandler
import TextEditor
import MarkdownEditor
import APIHandler
import Popup

struct Settings_ConnectionView: View {
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var popup: PopupHandler
    
    @State private var isConnectedToOpenAI: Bool = false
    @State private var isLoadingConnection: Bool = false
    @State private var isKeyUnlocked = false
    @State private var apiKey: String = ""
    
    @FocusState private var isEditorFocused
    
    let apiKeyString: String = "openAIAPIKey"
    
    var body: some View {
        
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
            
        } // End connection section

    }
}

extension Settings_ConnectionView {
    
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
    Settings_ConnectionView()
}
