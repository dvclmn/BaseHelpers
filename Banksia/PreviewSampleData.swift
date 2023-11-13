//
//  PreviewSampleData.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftData
import SwiftUI

/**
 Preview sample data.
 */
actor PreviewSampleData {

    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Conversation.self, UserPrompt.self, GPTResponse.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Conversation.preview
        ]
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}
