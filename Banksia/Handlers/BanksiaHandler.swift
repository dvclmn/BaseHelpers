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


extension Styles {
    static let paddingGutter: Double = 12
}

class BanksiaHandler: ObservableObject {
    
    @Published var hasProvidedAPIKey: Bool = false
    
    @Published var isQuickOpenShowing: Bool = false
    
//    @Published var appFocus: AppFocus = .editor
    
    //    @Published var isRequestingNextQuickOpenItem: Bool = false
    //    @Published var isRequestingPreviousQuickOpenItem: Bool = false
    //
    //    @Published var isNextQuickOpenAvailable: Bool = false
    //    @Published var isPreviousQuickOpenAvailable: Bool = false
    
    //    @Published var isGlobalConversationPreferencesShowing: Bool = false
    @Published var isEditingLongFormText: Bool = false
    
    @Published var isToolbarExpanded: Bool = false
    
    /// Debug window
    @AppStorage("isColumnOneShowingKey") var isColumnOneShowing: Bool = true
    @AppStorage("isColumnTwoShowingKey") var isColumnTwoShowing: Bool = true
    @AppStorage("isColumnthreeShowingKey") var isColumnThreeShowing: Bool = true
    
    @AppStorage("textScaleKey") var textScale: Double = 1.0
    @AppStorage("gptTemperatureKey") var gptTemperature: Double = 0.5
    @AppStorage("gptModelKey") var gptModel: GPTModel = GPTModel.gpt_4_turbo
    
    @AppStorage("editorHeightKey") var editorHeight: Double = 180
    
    @AppStorage("userNameKey") var userName: String?

    @AppStorage("isToolbarShowingKey") var isToolbarShowing: Bool = true
    
    @AppStorage("isDebugShowingKey") var isDebugShowing: Bool = false
    @AppStorage("isTestModeKey") var isTestMode: Bool = false
    
    @AppStorage("systemPromptKey") var systemPrompt: String = ""
    
    @AppStorage("uiDimmingKey") var uiDimming: Double = 0.30
    @AppStorage("defaultGrainientSeedKey") var defaultGrainientSeed: Int = 358962
    
    @AppStorage("isMessageInfoShowingKey") var isMessageInfoShowing: Bool = true
    
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
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()
        let formattedDate = dateFormatter.string(from: Date.now)
        
        let fileName: String = "Banksia_backup_\(formattedDate).json"
        let verb: String = "Export"
        
        do {
            let jsonData = try encoder.encode(exportData)
            
            // Save the JSON to a temporary file
            let fileManager = FileManager.default
            let tempDirectory = fileManager.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(fileName)
            try jsonData.write(to: fileURL)
            
            // Show save panel to the user
            let savePanel = NSSavePanel()
            savePanel.directoryURL = tempDirectory
            savePanel.nameFieldLabel = "\(verb) as:"
            savePanel.nameFieldStringValue = fileName
            savePanel.prompt = verb
            savePanel.title = verb
            savePanel.allowedContentTypes = [.json]
            
            if savePanel.runModal() == .OK {
                if let selectedURL = savePanel.url {
                    // Check if the file already exists at the destination
                    if fileManager.fileExists(atPath: selectedURL.path) {
                        // Remove the existing file
                        try fileManager.removeItem(at: selectedURL)
                    }
                    // Move the temporary file to the selected location
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

//import UniformTypeIdentifiers
//
//struct BanksiaExportedData: FileDocument {
//
//    static public var readableContentTypes: [UTType] =
//    [.json]
//
//    var text: String = ""
//
//    init(_ text: String = "") {
//        self.text = text
//    }
//}
