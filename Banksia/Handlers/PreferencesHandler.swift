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
    @AppStorage("gptModelKey") var gptModel: AIModel = AIModel.gpt_4_turbo
    
//    @AppStorage("editorHeightKey") var editorHeight: Double = 300
    
    @AppStorage("userNameKey") var userName: String?
    
    @AppStorage("systemPromptKey") var systemPrompt: String = ""
    
//    @AppStorage("userPromptKey") var userPrompt: String = ""
    
    
    
}
