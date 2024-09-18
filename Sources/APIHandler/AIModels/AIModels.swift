// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum AIProvider: CaseIterable, Codable, Sendable, Equatable {
  
  case openAI
  case anthropic
  
  public var name: String {
    switch self {
      case .openAI:
        OpenAI.name
      case .anthropic:
        Anthropic.name
    }
  }
  public var apiKey: String {
    switch self {
      case .openAI:
        OpenAI.apiKey
      case .anthropic:
        Anthropic.apiKey
    }
  }
  
  public var endpoint: URL? {
    switch self {
      case .openAI:
        OpenAI.endpoint
      case .anthropic:
        Anthropic.endpoint
    }
  }
  
  //    public var streamOptions: OpenAIRequestBody.StreamOptions? {
  //        switch self {
  //        case .openAI:
  //                .init(include_usage: true)
  //        case .anthropic:
  //            nil
  //        }
  //    }
  
  public var testEndpoint: URL? {
    switch self {
      case .openAI:
        URL(string: "https://api.openai.com/v1/models")
      case .anthropic:
        URL(string: "https://api.openai.com/v1/models")
    }
  }
  
  public var requestBody: AIRequestBody.Type {
    switch self {
      case .openAI:
        OpenAIRequestBody.self
      case .anthropic:
        AnthropicRequestBody.self
    }
  }
  
  public var testConnection: ProviderTestable.Type {
    switch self {
      case .openAI:
        OpenAITestConnection.self
      case .anthropic:
        AnthropicTestConnection.self
    }
  }
}


public protocol ProviderTestable {
  static func test(using key: String) async -> Bool
}

enum AIConnectionError: Error {
  case invalidRequest
  case authenticationFailed
  case networkError(Error)
  case unknownError(String)
}

@MainActor
public struct OpenAITestConnection: ProviderTestable {
  public static func test(using key: String) async -> Bool {
    print("Let's make a request, using key: `\(key)` to check connection to OpenAI")
    
    do {
      guard let request = try APIHandler.createRequest(
        url: AIProvider.openAI.testEndpoint,
        headers: ["Authorization" : "Bearer \(key)"]
      ) else {
        print("Problem with request for AI")
        //        throw AIConnectionError.invalidRequest
        
        return false
        
      }
      
      do {
        if let _: OpenAIConfirmationResponse = try await APIHandler.fetch(request: request) {
          print("Connected to open ai")
          return true
        } else {
          //          throw AIConnectionError.unknownError("Unexpected response format")
          return false
        }
      } catch  {
        return false
      }
      
    } catch {
      print("Issue with building URL request and/or API response for OpenAI: \(error)")
      return false
    }
  } // END open ai test
  
}

@MainActor
public struct AnthropicTestConnection: ProviderTestable {
  
  public static func test(using key: String) async -> Bool {
    

//    print("Let's make a request, to check connection to Anthropic")
    let body: AnthropicRequestBody = AnthropicRequestBody(
      model: AIModel.claude_3_haiku.reference,
      messages: [RequestMessage(role: "user", content: "Hello, is this thing on?")],
      stream: false,
      temperature: 0.5,
      system: "",
      max_tokens: 1
    )
    
//    print("The body: \(body)")
    
    do {
      guard let request = try APIHandler.createRequest(
        url: Anthropic.endpoint,
        body: body,
        headers: [
          Anthropic.authHeaderKey : "\(key)",
          Anthropic.contentTypeHeaderKey : Anthropic.contentTypeHeaderValue,
          Anthropic.versionHeaderKey : Anthropic.versionHeaderValue
        ]
      ) else {
        print("Problem with request for anthropic")
        return false
      }
      
//      print("The request for Anthropic: \(request)")
      
      if let _: AnthropicResponse = try await APIHandler.fetch(request: request) {
        print("Connected to anthropic")
        return true
      } else {
        return false
      }
      
      
    } catch {
      print("Issue with building URL request and/or API response for Anthropic: \(error) ")
      return false
    }
    
    
    
    
    
  } // END test
  
  
}

/// This has to conform to `String` so it can be saved to UserDefaults
public enum AIModel: String, CaseIterable, Identifiable, Codable, Equatable, Sendable {
  case gpt_4o
  case gpt_4o_mini
  case gpt_4_turbo
  case gpt_4
  case gpt_3_5_turbo
  
  case claude_3_5_sonnet
  case claude_3_opus
  case claude_3_sonnet
  case claude_3_haiku
  
  public var id: String {
    self.reference
  }
  
  public var name: String {
    switch self {
      case .gpt_4o:
        return "GPT-4o"
        
      case .gpt_4o_mini:
        return "GPT-4o mini"
        
      case .gpt_4_turbo:
        return "GPT-4 Turbo"
        
      case .gpt_4:
        return "GPT-4"
        
      case .gpt_3_5_turbo:
        return "GPT-3.5 Turbo"
        
        
      case .claude_3_5_sonnet:
        return "Claude 3.5 Sonnet"
        
      case .claude_3_opus:
        return "Claude 3 Opus"
        
      case .claude_3_sonnet:
        return "Claude 3 Sonnet"
        
      case .claude_3_haiku:
        return "Claude 3 Haiku"
    }
  }
  
  public var openAIModels: [AIModel] {
    AIModel.allCases.filter {$0.provider == .openAI}
  }
  
  public var anthropicModels: [AIModel] {
    AIModel.allCases.filter {$0.provider == .anthropic}
  }
  
  public var provider: AIProvider {
    switch self {
      case
          .gpt_4o,
          .gpt_4o_mini,
          .gpt_4_turbo,
          .gpt_4,
          .gpt_3_5_turbo:
        return .openAI
        
      case
          .claude_3_5_sonnet,
          .claude_3_opus,
          .claude_3_sonnet,
          .claude_3_haiku:
        return .anthropic
    }
  }
  
  
  public var reference: String {
    switch self {
      case .gpt_4o:
        return "gpt-4o"
        
      case .gpt_4o_mini:
        return "gpt-4o-mini"
        
      case .gpt_4_turbo:
        return "gpt-4-turbo"
        
      case .gpt_4:
        return "gpt-4"
        
      case .gpt_3_5_turbo:
        return "gpt-3.5-turbo"
        
      case .claude_3_5_sonnet:
        return "claude-3-5-sonnet-20240620"
        
      case .claude_3_opus:
        return "claude-3-opus-20240229"
        
      case .claude_3_sonnet:
        return "claude-3-sonnet-20240229"
        
      case .claude_3_haiku:
        return "claude-3-haiku-20240307"
        
    }
  }
  
  public var isNew: Bool {
    switch self {
      case .gpt_4o, .gpt_4o_mini:
        true
        
      case .gpt_4_turbo, .gpt_4, .gpt_3_5_turbo:
        false
        
      case .claude_3_5_sonnet:
        true
        
      case .claude_3_opus, .claude_3_sonnet, .claude_3_haiku:
        false
    }
  }
  
  public var speed: String? {
    switch self {
        
      case .gpt_4o, .gpt_4o_mini, .gpt_4_turbo, .gpt_4, .gpt_3_5_turbo:
        return nil
        
      case .claude_3_5_sonnet:
        return "Fast"
      case .claude_3_opus:
        return "Moderately fast"
      case .claude_3_sonnet:
        return "Fast"
      case .claude_3_haiku:
        return "Fastest"
    }
  }
  
  public var contextLength: Double {
    switch self {
      case .gpt_4o, .gpt_4o_mini, .gpt_4_turbo:
        return 128000
      case .gpt_4:
        return 8192
      case .gpt_3_5_turbo:
        return 16385
      case .claude_3_5_sonnet, .claude_3_opus, .claude_3_sonnet, .claude_3_haiku:
        return 200000
    }
  }
  
  public var cutoff: String {
    switch self {
      case .gpt_4o, .gpt_4o_mini:
        "Oct 2023"
        
      case .gpt_4_turbo:
        "Dec 2023"
        
      case .gpt_4, .gpt_3_5_turbo:
        "Sep 2021"
        
        
      case .claude_3_5_sonnet:
        "April 2024"
        
      case .claude_3_opus, .claude_3_sonnet:
        "August 2023"
        
      case .claude_3_haiku:
        "March 2024"
    }
  }
  
  public var successor: AIModel? {
    switch self {
      case .gpt_3_5_turbo:
          .gpt_4o_mini
      default: nil
    }
  }
  
  public var blurb: String {
    switch self {
      case .gpt_4o:
        "Latest flagship model. More efficient and affordable than GPT-4 Turbo."
        
      case .gpt_4o_mini:
        "An affordable and intelligent small model for fast, lightweight tasks. GPT-4o mini is cheaper and more capable than GPT-3.5 Turbo. Better suited to smaller tasks; for larger tasks look to GPT-4o."
        
      case .gpt_4_turbo:
        "Large multimodal model*, capable of solving difficult problems with greater accuracy than previous OpenAI models. Broad general knowledge and advanced reasoning capabilities. *(Multimodality not yet supported by Banksia)"
      case .gpt_4:
        "Large multimodal model*, capable of solving difficult problems with greater accuracy than previous OpenAI models. Broad general knowledge and advanced reasoning capabilities. *(Multimodality not yet supported by Banksia)"
      case .gpt_3_5_turbo:
        "Fast, inexpensive model for simple tasks."
      case .claude_3_5_sonnet:
        "Model with the highest level of intelligence and capability."
      case .claude_3_opus:
        "Powerful model for highly complex tasks. Top-level performance, intelligence, fluency, and understanding."
      case .claude_3_sonnet:
        "Balance of intelligence and speed. Strong utility, balanced for scaled deployments."
      case .claude_3_haiku:
        "Fastest and most compact model for near-instant responsiveness. Quick and accurate targeted performance."
    }
  }
  
  public var maxTokenOutput: Double? {
    switch self {
      case .gpt_4o, .gpt_4o_mini, .gpt_4_turbo, .gpt_4, .gpt_3_5_turbo:
        return nil
        
      case .claude_3_5_sonnet, .claude_3_opus, .claude_3_sonnet, .claude_3_haiku:
        return 4096
    }
  }
  
  public var inputOutputCost: (Double, Double) {
    switch self {
      case .gpt_4o:
        (5, 15)
        
      case .gpt_4o_mini:
        (0.15, 0.6)
        
      case .gpt_4_turbo:
        (10, 30)
        
      case .gpt_4:
        (30, 60)
        
      case .gpt_3_5_turbo:
        (0.5, 1.5)
        
      case .claude_3_5_sonnet, .claude_3_sonnet:
        (3, 15)
        
      case .claude_3_opus:
        (15, 75)
        
      case .claude_3_haiku:
        (0.25, 1.25)
    }
  }
  
  public var isMultiModal: Bool {
    switch self {
        
      case .gpt_4o, .gpt_4_turbo, .gpt_4o_mini, .gpt_4:
        true
        
      case .gpt_3_5_turbo:
        false
        
      case .claude_3_5_sonnet, .claude_3_sonnet, .claude_3_opus, .claude_3_haiku:
        true
        
    }
  }
  
  public var informationCorrectAsOf: Date {
    let dateComponents = DateComponents(year: 2024, month: 7, day: 20)
    let calendar = Calendar.current
    return calendar.date(from: dateComponents) ?? .now
  }
  
}
