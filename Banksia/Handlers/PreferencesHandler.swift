//
//  PreferencesHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI

final class Preferences: ObservableObject {
    @AppStorage("textScaleKey") var textScale: Double = 1.0
    @AppStorage("gptTemperatureKey") var gptTemperature: Double = 0.5
    @AppStorage("gptModelKey") var gptModel: GPTModel = GPTModel.gpt_4_turbo
    
    @AppStorage("editorHeightKey") var editorHeight: Double?
    
    @AppStorage("userNameKey") var userName: String?
    
    @AppStorage("isDebugShowingKey") var isDebugShowing: Bool = false
    
    @AppStorage("systemPromptKey") var systemPrompt: String = ""
    
    @AppStorage("uiDimmingKey") var uiDimming: Double = 0.30
    @AppStorage("defaultGrainientSeedKey") var defaultGrainientSeed: Int = 358962

    
}
