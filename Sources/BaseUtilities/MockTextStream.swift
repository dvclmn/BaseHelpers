//
//  MockupTextStream.swift
//
//
//  Created by Dave Coleman on 18/7/2024.
//

import Foundation
import SwiftUI
import TestStrings

enum TextChunkError: Error {
    case cancelled
}

public class MockupTextStream {
    
    public static func chunks(
        from text: String? = nil,
        chunkSize: Int = 5,
        speed: Int = 200
    ) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    for chunk in splitContentPreservingWhitespace(text, chunkSize: chunkSize) {
                        try Task.checkCancellation()
                        continuation.yield(chunk)
                        try await Task.sleep(for: .milliseconds(speed))
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private static func splitContentPreservingWhitespace(_ content: String? = nil, chunkSize: Int = 5) -> [String] {
        var chunks: [String] = []
        var currentChunk = ""
        var wordCount = 0
        
        var textContent: String = ""
        
        if let content = content {
            textContent = content
        } else {
            textContent = TestStrings.paragraphsWithCode[0]
        }
        
        for character in textContent {
            currentChunk.append(character)
            
            if character.isWhitespace || character.isNewline {
                wordCount += 1
                if wordCount >= chunkSize {
                    chunks.append(currentChunk)
                    currentChunk = ""
                    wordCount = 0
                }
            }
        }
        
        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }
        
        return chunks
    }
}

