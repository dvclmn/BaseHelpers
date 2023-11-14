//
//  Preview+ModelContainer.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftData

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([Conversation.self, UserPrompt.self, GPTResponse.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Task { @MainActor in
            Conversation.insertSampleData(modelContext: container.mainContext)
        }
        return container
    }
}
