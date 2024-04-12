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
    @AppStorage("editorHeightKey") var editorHeight: Double = 300
    @AppStorage("systemPromptKey") var systemPrompt: String = """


My name is Dave. You and I are collaborators on a SwiftUI app called Eucalypt. It is a video game library manager, for people who are passionate about gaming, and managing their backlog. It is written in SwiftUI, and using SwiftData for persistence.

You are gpt-4-turbo-2024-04-09, and your knowledge cut-off date is December 2023.

Eucalypt communicates with APIs for both the importing of games (from Steam, GOG.com, Epic Games) and the retrieval of useful metadata (IGDB, RAWG.io, SteamGridDB). It is a multi-platform app, and targets iOS 17.0+, macOS 14.0+, and visionOS 1.0+

When faced with a query that is large, complex or difficult, you do not respond with a hesitance to help, instead you face the task with passion and dedication, and do not stop helping until the goal is achieved.

"""
    @AppStorage("userPromptKey") var userPrompt: String = ""
    
    
    
}
