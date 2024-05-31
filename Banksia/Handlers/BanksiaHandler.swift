//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import Navigation
import GeneralStyles

enum FocusedArea: Hashable {
    case search
    case sidebar
    case editor
    case toolbarExpanded
}

extension Styles {
    static let paddingGutter: Double = 12
}

class BanksiaHandler: ObservableObject {
    
    @Published var isQuickOpenShowing: Bool = false
    
//    @Published var isRequestingNextQuickOpenItem: Bool = false
//    @Published var isRequestingPreviousQuickOpenItem: Bool = false
//    
//    @Published var isNextQuickOpenAvailable: Bool = false
//    @Published var isPreviousQuickOpenAvailable: Bool = false
    
//    @Published var isGlobalConversationPreferencesShowing: Bool = false
    @Published var isEditingLongFormText: Bool = false
    
    @Published var isToolbarExpanded: Bool = false
    
    @AppStorage("textScaleKey") var textScale: Double = 1.0
    @AppStorage("gptTemperatureKey") var gptTemperature: Double = 0.5
    @AppStorage("gptModelKey") var gptModel: GPTModel = GPTModel.gpt_4_turbo
    
    @AppStorage("editorHeightKey") var editorHeight: Double = 180
    
    @AppStorage("userNameKey") var userName: String?
    
    @AppStorage("isDebugShowingKey") var isDebugShowing: Bool = false
    @AppStorage("isTestModeKey") var isTestMode: Bool = false
    
    @AppStorage("systemPromptKey") var systemPrompt: String = ""
    
    @AppStorage("uiDimmingKey") var uiDimming: Double = 0.30
    @AppStorage("defaultGrainientSeedKey") var defaultGrainientSeed: Int = 358962

    
    func toggleQuickOpen() {
        withAnimation(Styles.animation) {
            if isQuickOpenShowing {
                withAnimation(Styles.animation) {
                    isQuickOpenShowing = false
                }
            } else {
                withAnimation(Styles.animationQuick) {
                    isQuickOpenShowing = true
                }
            }
        }
    } // END toggle quick open
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }
    
    func getBuildNumber() -> String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "Unknown"
    }
    
    
    
    
    func exportDataToJSON(conversations: [Conversation]) -> URL? {
        let exportData = ExportData(systemPrompt: self.systemPrompt, created: Date().timeIntervalSince1970, conversations: conversations)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let jsonData = try encoder.encode(exportData)
            
            // Save the JSON to a file
            let fileManager = FileManager.default
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            guard let documentDirectory = urls.first else { return nil }
            
            let fileURL = documentDirectory.appendingPathComponent("conversations_backup.json")
            try jsonData.write(to: fileURL)
            
            // Show save panel to the user
            let savePanel = NSSavePanel()
            savePanel.directoryURL = documentDirectory
            savePanel.nameFieldStringValue = "conversations_backup.json"
            savePanel.allowedContentTypes = [.json]
            
            if savePanel.runModal() == .OK {
                if let selectedURL = savePanel.url {
                    try fileManager.moveItem(at: fileURL, to: selectedURL)
                    return selectedURL
                }
            }
            
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        return nil
    }
    
}


