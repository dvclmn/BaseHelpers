//
//  LLMModel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

extension DummyContent {
  
  public struct LLM: Identifiable, Codable, Sendable {
    
    public var id = UUID()
    var name: String
    var isNew: Bool = false
    var speed: String? = nil
    var reference: String
    var contextLength: Double = 200000
    var cutoff: String = "August 2023"
    var blurb: String
    var maxTokenOutput: Double? = 4096
    var inputCost: Double
    var outputCost: Double
    var infoURLSlug: String? = nil
    
    
    static let gpt_4o = Self(
      name: "GPT-4o",
      isNew: true,
      reference: "gpt-4o",
      contextLength: 128000,
      cutoff: "Apr 2024",
      blurb: "Latest flagship model. More efficient and affordable than GPT-4 Turbo.",
      
      inputCost: 5,
      outputCost: 15,
      infoURLSlug: "gpt-4o"
    )
    
    static let gpt_4_turbo = Self(
      name: "GPT-4 Turbo",
      reference: "gpt-4-turbo",
      contextLength: 128000,
      blurb:
        "Large multimodal model*, capable of solving difficult problems with greater accuracy than previous OpenAI models. Broad general knowledge and advanced reasoning capabilities. *(Multimodality not yet supported by Banksia)",
      inputCost: 10,
      outputCost: 30,
      infoURLSlug: "gpt-4-turbo-and-gpt-4"
    )
    
    static let gpt_4 = Self(
      name: "GPT-4",
      reference: "gpt-4",
      contextLength: 8192,
      blurb:
        "Large multimodal model*, capable of solving difficult problems with greater accuracy than previous OpenAI models. Broad general knowledge and advanced reasoning capabilities. *(Multimodality not yet supported by Banksia)",
      inputCost: 30,
      outputCost: 60,
      infoURLSlug: "gpt-4-turbo-and-gpt-4"
    )
    
    static let gpt_3_5_turbo = Self(
      name: "GPT-3.5 Turbo",
      reference: "gpt-3.5-turbo",
      contextLength: 16385,
      blurb: "Fast, inexpensive model for simple tasks.",
      inputCost: 0.5,
      outputCost: 1.5,
      infoURLSlug: "gpt-3-5-turbo"
    )
  }

}
