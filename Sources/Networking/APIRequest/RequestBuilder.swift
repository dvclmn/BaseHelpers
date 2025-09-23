//
//  RequestBuilder.swift
//  Networking
//
//  Created by Dave Coleman on 3/3/2025.
//

//import Foundation

/// Example usage:
///
/// ```
/// let request = try APIRequest<AnthropicTokenCount> {
///   Authenticator(auth)
///   URL("https://api.anthropic.com/v1/messages/count_tokens")
///   Method(.post)
///   Header("Content-Type", "application/json")
///   Header("x-api-key", token)
///   Body(requestPayload)
/// }
///
/// let response = try await request.fetch()
///
/// ```
/// Also:
/// ```
/// let request = try APIRequest {
///   DTO(AnthropicTokenCount.self)
///   URL("https://api.anthropic.com/v1/messages/count_tokens")
///   Method(.post)
///   Headers {
///     APIHeader("Content-Type", "application/json")
///     APIHeader("x-api-key", token)
///   }
///   Body(requestPayload)
/// }
///
/// let response = try await request.fetch()
///
/// ```
#warning("Bring this back and implement, as it looks really useful and nice")

//@resultBuilder
//public struct APIRequestBuilder {
//  public static func buildBlock<T: Decodable>(_ components: APIRequestComponent<T>...) -> [APIRequestComponent<T>] {
//    return components
//  }
//  
//  public static func buildOptional<T: Decodable>(_ component: [APIRequestComponent<T>]?) -> [APIRequestComponent<T>] {
//    return component ?? []
//  }
//  
//  public static func buildEither<T: Decodable>(first component: [APIRequestComponent<T>]) -> [APIRequestComponent<T>] {
//    return component
//  }
//  
//  public static func buildEither<T: Decodable>(second component: [APIRequestComponent<T>]) -> [APIRequestComponent<T>] {
//    return component
//  }
//  
//  public static func buildArray<T: Decodable>(_ components: [[APIRequestComponent<T>]]) -> [APIRequestComponent<T>] {
//    return components.flatMap { $0 }
//  }
//}
