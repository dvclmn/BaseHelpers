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
    
    func toggleExpanded() {
        isToolbarExpanded.toggle()
    }
    
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
    
}


