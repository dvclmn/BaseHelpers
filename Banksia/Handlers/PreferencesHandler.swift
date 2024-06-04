//
//  PreferencesHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import Swatches

final class Preferences: ObservableObject {
    
    @AppStorage("textScaleKey") var textScale: Double = 1.0
    
    @AppStorage("gptTemperatureKey") var gptTemperature: Double = 0.5
    
    @AppStorage("gptModelKey") var gptModel: GPTModel = GPTModel.gpt_4_turbo
    
    @AppStorage("accentColourKey") var accentColour: Swatch = Swatch.chalkBlue
    
    @AppStorage("editorHeightKey") var editorHeight: Double = 180
    
    @AppStorage("userNameKey") var userName: String?

    @AppStorage("isToolbarShowingKey") var isToolbarShowing: Bool = true
    
    @AppStorage("isDebugShowingKey") var isDebugShowing: Bool = false
    @AppStorage("isTestModeKey") var isTestMode: Bool = false
    
    @AppStorage("systemPromptKey") var systemPrompt: String = ""
    
    @AppStorage("uiDimmingKey") var uiDimming: Double = 0.30
    @AppStorage("defaultGrainientSeedKey") var defaultGrainientSeed: Int = 358962
    
    @AppStorage("isMessageInfoShowingKey") var isMessageInfoShowing: Bool = true
    
    @AppStorage("isWelcomeScreenEnabledKey") var isWelcomeScreenEnabled: Bool = true
    
}
