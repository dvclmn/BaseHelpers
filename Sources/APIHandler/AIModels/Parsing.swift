//
//  File.swift
//
//
//  Created by Dave Coleman on 20/7/2024.
//

import Foundation

public struct ParseHandler {
  
  public init() {}
  
//  public private(set) var tokens: Tokens = .init()
//  
//  public init() {
//  }
//  
//  public struct Tokens {
//    public let inputTokens: Int
//    public let outputTokens: Int
//    
//    public init(
//      inputTokens: Int = 0,
//      outputTokens: Int = 0
//    ) {
//      self.inputTokens = inputTokens
//      self.outputTokens = outputTokens
//    }
//  }
//  
//  mutating func updateTokens(
//    inputTokens: Int? = nil,
//    outputTokens: Int? = nil
//  ) {
//    
//    print("Updating tokens.")
//    
//    self.tokens = Tokens(
//      inputTokens: inputTokens ?? tokens.inputTokens,
//      outputTokens: outputTokens ?? tokens.outputTokens
//    )
//  }
  
  
  
  public mutating func parseLine(_ line: String, for provider: AIProvider) -> (String?, Int?, Int?) {
    
    /// Regarding input/output tokens
    ///
    /// Anthropic:
    /// The `usage.input_tokens` value in the `message_start` event type
    /// counts the total number of tokens, including system/conversation prompt etc,
    /// from the user's prompt.
    ///
    /// Then, to obtain the final `output_tokens` count, use the `usage.output_tokens`
    /// value from the `message_delta` event type.
    ///
    /// Remember:
    /// `input_tokens` = What the user wrote to the LLM
    /// `output_tokens` = What the LLM wrote back in response
    ///
    
    /// Example SSE output:
    ///
    /// ```
    /// event: ping
    /// data: {"type": "ping"}
    ///
    /// ```
    
    /// The below applies to both Anthropic and OpenAI, unless otherwise specificed
    ///
    guard line.starts(with: "data: ") else {
      print("Line didn't start with `data: `, so discarding it: \(line)")
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
    
    var content: String?
    var inputTokens: Int?
    var outputTokens: Int?
    
    switch provider {
        
      case .openAI:
        
        guard let chunk: OpenAIStreamedResponse = ParseHandler.decodeStreamedResponse(message) else {
          return (nil, nil, nil)
        }
        content = chunk.responseData?.text
        inputTokens = chunk.usage?.input_tokens
        outputTokens = chunk.usage?.output_tokens

      case .anthropic:
        
        if message.contains("message_start") {
          
          print("Operating on a line that contains `message_start`: \(message)")
          
          /// `message_start` contains *only* the input tokens, in terms of useful data
          
          guard let chunk: AnthropicMessageStart = ParseHandler.decodeStreamedResponse(message) else {
            print("No result for `message_start`: \(message)")
            return (nil, nil, nil)
          }
         
          content = nil
          inputTokens = chunk.usage?.input_tokens
          outputTokens = nil
          
          
          
        } else if message.contains("content_block_delta") {
          
          print("Operating on a line that contains `content_block_delta`: \(message)")
          
          /// `content_block_delta` contains the actual response text
          ///
          guard let chunk: AnthropicContentBlockDelta =  ParseHandler.decodeStreamedResponse(message) else {
            print("No result for `content_block_delta`: \(message)")
            return (nil, nil, nil)
          }
          content = chunk.responseData?.text
          inputTokens = nil
          outputTokens = nil
          
          
        } else if message.contains("message_delta") {
          
          print("Operating on a line that contains `message_delta`: \(message)")
          
          /// `message_delta` contains the remaining output tokens usage, which we will then add to the total output token count
          guard let chunk: AnthropicMessageDelta =  ParseHandler.decodeStreamedResponse(message) else {
            print("No result for `message_delta`: \(message)")
            return (nil, nil, nil)
          }
          
          /// `message_delta` only provides output tokens
          content = nil
          inputTokens = nil
          outputTokens = chunk.usage?.output_tokens

        } else {
          print("No need to process this line, does not contain information that I need for now: \(message)")
        } // END line contains "x" checks
        
        
    } // END provider switch
    return (content, inputTokens, outputTokens)
    
  } // END parse message
  
  
  private static func printInfo(for data: (String?, Int?, Int?, Int?, Int?), withTitle title: String) {
    print("""
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
      print("Couldn't convert string to data")
      return nil
    }
    
    let decoder = JSONDecoder()
    
    do {
      let decodedResponse = try decoder.decode(T.self, from: data)
      return decodedResponse
    } catch {
      print("Error decoding streamed line: \(error)")
    }
    
    return nil
    
    
  } // END parse message
  
}
