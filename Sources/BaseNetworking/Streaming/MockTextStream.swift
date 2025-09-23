//
//  MockupTextStream.swift
//
//
//  Created by Dave Coleman on 18/7/2024.
//

import BaseHelpers
import Foundation
import SwiftUI

/// A service that provides simulated streaming responses for testing UI
public struct MockStreamingService: Sendable {
  
  /// Controls the speed of streaming (characters per second)
  var charactersPerSecond: Double
  var chunkSize: ClosedRange<Int>
  
  public init(
    charactersPerSecond: Double = 20,
    chunkSize: ClosedRange<Int> = 1...5
  ) {
    self.charactersPerSecond = charactersPerSecond
    self.chunkSize = chunkSize
  }
  
  /// Get a random sample response
  func randomResponse() -> String {
    TestStrings.paragraphs.randomElement() ?? TestStrings.paragraphs[0]
  }
  
  /// Core chunking function used by both stream types
  private func streamChunks(
    from text: String,
    chunkHandler: @Sendable @escaping (String) async throws -> Void
  ) async throws {
    var remainingText = text
    
    while !remainingText.isEmpty {
      /// Determine chunk size (between 1-5 characters)
      let chunkSize = min(Int.random(in: chunkSize), remainingText.count)
      let index = remainingText.index(remainingText.startIndex, offsetBy: chunkSize)
      let chunk = String(remainingText[..<index])
      
      /// Process the chunk using the provided handler
      try await chunkHandler(chunk)
      
      /// Remove the sent chunk from remaining text
      remainingText = String(remainingText[index...])
      
      /// Calculate delay based on characters per second
      let delaySeconds = Double(chunkSize) / charactersPerSecond
      try await Task.sleep(for: .seconds(delaySeconds))
    }
  }
  /// Create a plain text stream for basic testing
  public func createStream(forcedResponse: String? = nil) -> AsyncStream<String> {
    let response = forcedResponse ?? randomResponse()
    
    return AsyncStream { continuation in
      Task { @MainActor in
        do {
          try await streamChunks(from: response) { chunk in
            continuation.yield(chunk)
          }
          continuation.finish()
        } catch {
          continuation.finish()
        }
      }
    }
  }
  
  /// Create a stream that simulates the SSE format from Anthropic
  public func createAnthropicStyleStream(forcedResponse: String? = nil) -> AsyncStream<String> {
    let response = forcedResponse ?? randomResponse()
    
    return AsyncStream { continuation in
      Task {
        /// Send initial event
        continuation.yield("event: message_start")
        continuation.yield(
          "data: {\"type\": \"message_start\", \"message\": {\"id\": \"msg_mock123\", \"type\": \"message\", \"role\": \"assistant\", \"content\": [], \"model\": \"claude-3-opus-20240229\", \"stop_reason\": null, \"stop_sequence\": null, \"usage\": {\"input_tokens\": 42, \"output_tokens\": 0}}}"
        )
        
        try? await Task.sleep(for: .seconds(0.2))
        
        do {
          /// Use the core chunking function with a custom handler for Anthropic format
          try await streamChunks(from: response) { chunk in
            continuation.yield("event: content_block_delta")
            continuation.yield(
              "data: {\"type\": \"content_block_delta\", \"delta\": {\"type\": \"text_delta\", \"text\": \"\(self.escapeJsonString(chunk))\"}, \"index\": 0}"
            )
          }
          
          // Send completion event
          continuation.yield("event: message_stop")
          continuation.yield(
            "data: {\"type\": \"message_stop\", \"message\": {\"id\": \"msg_mock123\", \"type\": \"message\", \"role\": \"assistant\", \"content\": [{\"type\": \"text\", \"text\": \"\(self.escapeJsonString(response))\"}], \"model\": \"claude-3-opus-20240229\", \"stop_reason\": \"end_turn\", \"stop_sequence\": null, \"usage\": {\"input_tokens\": 42, \"output_tokens\": \(response.count / 4)}}}"
          )
        } catch {
          // In a more complete implementation, you might want to simulate error events here
        }
        
        continuation.finish()
      }
    }
  }
  
  /// Helper to escape special characters in JSON strings
  private func escapeJsonString(_ string: String) -> String {
    string
      .replacingOccurrences(of: "\\", with: "\\\\")
      .replacingOccurrences(of: "\"", with: "\\\"")
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\r", with: "\\r")
      .replacingOccurrences(of: "\t", with: "\\t")
  }
}


//
//enum TextChunkError: Error {
//  case cancelled
//}
//
//public class MockupTextStream {
//
//  public static func chunks(
//    from text: String? = nil,
//    chunkSize: Int = 5,
//    speed: Int = 200
//  ) -> AsyncThrowingStream<String, Error> {
//    AsyncThrowingStream { continuation in
//      Task {
//        do {
//          for chunk in splitContentPreservingWhitespace(text, chunkSize: chunkSize) {
//            try Task.checkCancellation()
//            continuation.yield(chunk)
//            try await Task.sleep(for: .milliseconds(speed))
//          }
//          continuation.finish()
//        } catch {
//          continuation.finish(throwing: error)
//        }
//      }
//    }
//  }
//
//  private static func splitContentPreservingWhitespace(_ content: String? = nil, chunkSize: Int = 5) -> [String] {
//    var chunks: [String] = []
//    var currentChunk = ""
//    var wordCount = 0
//
//    var textContent: String = ""
//
//    if let content = content {
//      textContent = content
//    } else {
//      textContent = "Need to find some longer example text"
//      //      textContent = TestStrings.paragraphsWithCode[0]
//    }
//
//    for character in textContent {
//      currentChunk.append(character)
//
//      if character.isWhitespace || character.isNewline {
//        wordCount += 1
//        if wordCount >= chunkSize {
//          chunks.append(currentChunk)
//          currentChunk = ""
//          wordCount = 0
//        }
//      }
//    }
//
//    if !currentChunk.isEmpty {
//      chunks.append(currentChunk)
//    }
//
//    return chunks
//  }
//}
