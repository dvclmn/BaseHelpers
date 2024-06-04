//
//  Settings+ConnectionView.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import Form
import Icons
import KeychainSwift
import TextEditor
import MarkdownEditor
import APIHandler
import Popup
import Button
import Table




struct Settings_ConnectionView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    
    let keychain = KeychainSwift()
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    
    @State private var isConnectedToOpenAI: Bool = false
    @State private var isLoadingConnection: Bool = false
    @State private var isKeyLocked = true
    @State private var apiKeyInput: String = ""
    
    let apiKeyString: String = "openAIAPIKey"
    
    var body: some View {
        
        //        CustomSection(label: "Connection", isCompact: false) {
        
        
        LabeledContent {
            Group {
                if !isKeyLocked {
                    TextField("API Key", text: $apiKeyInput, prompt: Text("Enter API Key"))
                    
                        .onSubmit {
                            Task {
                                await submitAPIKey()
                                isKeyLocked = true
                            }
                        }
                } else {
                    SecureField("API Key", text: $apiKeyInput, prompt: Text("Enter API Key"))
                        .foregroundStyle(.secondary)
                        .onSubmit {
                            Task {
                                await submitAPIKey()
                            }
                        }
                }
            } // END text fields group
            .textFieldStyle(.customField(
                text: $apiKeyInput,
                status: isKeyLocked ? .disabled : .active,
                actionLabel: isKeyLocked ? "Show key" : "Hide key",
                actionIcon: Icons.eye.icon
            ) {
                isKeyLocked.toggle()
            })
            
            .onAppear {
                
                Task {
                    if let key = keychain.get(apiKeyString) {
                        apiKeyInput = key
                        isConnectedToOpenAI = await verifyOpenAIConnection()
                    } else {
                        keychain.set(apiKeyInput, forKey: apiKeyString)
                        isConnectedToOpenAI = false
                    }
                    
                }
            } // END on appear
        } label: {
            Label("API Key", systemImage: Icons.key.icon)
            
            if !apiKeyInput.isEmpty {
                HStack(spacing: 0) {
                    Text("Status: **\(isConnectedToOpenAI ? "Connected" : "No connection")**")
                    if isLoadingConnection {
                        Image(systemName: Icons.rays.icon)
                            .spinning()
                    }
                }
                //                        .fixedSize(horizontal: true, vertical: false)
            }
        }
        .labeledContentStyle(.customLabeledContent())
        
        
        
        LabeledContent {
            Picker("Select model", selection: $pref.gptModel) {
                ForEach(GPTModel.allCases, id: \.self) { model in
                    Text(model.name).tag(model.model)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        } label: {
            
            Label("Select model", systemImage: Icons.shocked.icon)
            
            
                               
            
            //                    Label("Select model", systemImage: Icons.shocked.icon)
            //                    Text("Current:\t\t\t**\(pref.gptModel.name)**")
            //                    Text("Context length:\t**\(pref.gptModel.contextLength) tokens**")
            //                    Text("Training cut-off:\t**\(pref.gptModel.cutoff)**")
        }
        .labeledContentStyle(.customLabeledContent())
        
        let rows: [CustomRow<GPTColumns>] = GPTModel.allCases.map { $0.toCustomRow() }
        
        CustomTable(columns: GPTColumns.allCases, rows: rows)
        
        
        
        //        } // End connection section
        
    }
}



extension Settings_ConnectionView {
    
    private func verifyOpenAIConnection() async -> Bool {
        
        isLoadingConnection = true
        
        guard let key = keychain.get(apiKeyString) else {
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
            print("Data from OpenAI: \(result.data)")
            
            isLoadingConnection = false
            return true
            
        } catch {
            isLoadingConnection = false
            return false
        }
        
    }
    
    private func submitAPIKey() async {
        
        if keychain.set(self.apiKeyInput, forKey: apiKeyString) {
            self.isConnectedToOpenAI = await verifyOpenAIConnection()
        } else {
            popup.showPopup(title: "Issue saving API Key", message: "Please try again.")
        }
    }
}


#Preview {
    
    SettingsView()
        .environment(BanksiaHandler())
        .environmentObject(Preferences())
        .environmentObject(PopupHandler())
        .frame(width: 400, height: 700)
}
