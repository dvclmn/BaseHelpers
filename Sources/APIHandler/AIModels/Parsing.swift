//
//  File.swift
//  
//
//  Created by Dave Coleman on 20/7/2024.
//

import Foundation
import OSLog

public struct ParseMessage {
    
    public static func parseMessage(_ line: String, for provider: AIProvider) -> (String?, Int?, Int?) {
        
//        /// This should keep `event:` out of the mix
//        guard !line.starts(with: "event: ") else {
//            os_log("No need for lines beginning `event: `")
//            return (nil, nil, nil)
//        }
//
        /// This applies to both Anth and OpenAI
        guard line.starts(with: "data: ") else {
            os_log("Line didn't start with `data: `, so ignoring it: \(line)")
            return (nil, nil, nil)
        }
        
        guard !line.contains("[DONE]") || !line.contains("message_stop") else {
            print("Message is all finished")
            return ("\n", nil, nil)
        }
        
        /// Remove white space
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /// Omit `data:` so it doesn't invalidate the JSON decoding
        let message = String(trimmed.dropFirst("data: ".count))
        
        switch provider {
        case .openAI:
            
            var content: String? = nil
            var inputTokens: Int? = nil
            var outputTokens: Int? = nil
            
            
                guard let chunk: OpenAIStreamedResponse =  decodeStreamedResponse(message) else {
                    return (nil, nil, nil)
                }
                content = chunk.responseData?.text
                inputTokens = chunk.usage?.input_tokens
                outputTokens = chunk.usage?.output_tokens
                
                printInfo(
                    for: (
                        content,
                        inputTokens,
                        nil,
                        nil,
                        outputTokens
                    ),
                    withTitle: "This is OpenAI, initial and remaining output token values will be nil, as they're not relevant"
                )
                
            
            return (content, inputTokens, outputTokens)
            
        case .anthropic:
            
            var content: String? = nil
            var inputTokens: Int? = nil
            
            var initialOutputTokens: Int? = nil
            
            var remainingOutputTokens: Int? = nil
            
            var totalOutputTokens: Int? = nil
            
            if message.contains("message_start") {
                
                os_log("Operating on a line that contains `message_start`: \(message)")
                
                /// `message_start` contains only the input tokens, and initial output tokens, in terms of useful data
                
                    guard let chunk: AnthropicMessageStart =  decodeStreamedResponse(message) else {
                        os_log("No result for `message_start`: \(message)")
                        return (nil, nil, nil)
                    }
                    content = nil
                    inputTokens = chunk.responseData?.usage?.input_tokens
                    initialOutputTokens = chunk.responseData?.usage?.output_tokens
                    remainingOutputTokens = nil
                    
                    printInfo(
                        for: (
                            content,
                            inputTokens,
                            initialOutputTokens,
                            remainingOutputTokens,
                            totalOutputTokens
                        ),
                        withTitle: "message_start"
                    )
                
                
            } else if message.contains("content_block_delta") {
                
                os_log("Operating on a line that contains `content_block_delta`: \(message)")
                
                
                    /// `content_block_delta` contains the actual response text
                    guard let chunk: AnthropicContentBlockDelta =  decodeStreamedResponse(message) else {
                        os_log("No result for `content_block_delta`: \(message)")
                        return (nil, nil, nil)
                    }
                    content = chunk.responseData?.text
                    inputTokens = nil
                    initialOutputTokens = nil
                    remainingOutputTokens = nil
                    
                    printInfo(
                        for: (
                            content,
                            inputTokens,
                            initialOutputTokens,
                            remainingOutputTokens,
                            totalOutputTokens
                        ),
                        withTitle: "content_block_delta"
                    )
                
                
            } else if message.contains("message_delta") {
                
                os_log("Operating on a line that contains `message_delta`: \(message)")
                
                /// `message_delta` contains the remaining output tokens usage, which we will then add to the total output token count
                
                    guard let chunk: AnthropicMessageDelta =  decodeStreamedResponse(message) else {
                        os_log("No result for `message_delta`: \(message)")
                        return (nil, nil, nil)
                    }
                    content = nil
                    inputTokens = nil
                    initialOutputTokens = nil
                    remainingOutputTokens = chunk.usage?.output_tokens
                    
                    if let initialOutput = initialOutputTokens, let remaining = remainingOutputTokens {
                        totalOutputTokens = initialOutput + remaining
                    }
                    
                    printInfo(
                        for: (
                            content,
                            inputTokens,
                            initialOutputTokens,
                            remainingOutputTokens,
                            totalOutputTokens
                        ),
                        withTitle: "message_delta"
                    )
                
                
            } else {
                os_log("No need to process this line, does not contain information that I need for now: \(message)")
            } // END line contains "x" checks
            
            return (content, inputTokens, totalOutputTokens)
            
        } // END provider switch
        
    } // END parse message
    
    
    private static func printInfo(for data: (String?, Int?, Int?, Int?, Int?), withTitle title: String) {
        os_log("""
        Here's what we got from `\(title)`:
        content: \(String(describing: data.0))
        inputTokens: \(String(describing: data.1))
        initialOutputTokens: \(String(describing: data.2))
        remainingOutputTokens: \(String(describing: data.3))
        totalOutputTokens: \(String(describing: data.4))
        """
        )
    }
    
    public static func decodeStreamedResponse<T: StreamedResponse>(_ line: String) -> T? {
        
        guard let data = line.data(using: .utf8) else {
            os_log("Couldn't convert string to data")
            return nil
        }
        
        let decoder = JSONDecoder()

        do {
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch {
            os_log("Error decoding streamed line: \(error)")
        }
        
        return nil
        
        
    } // END parse message
    
}
