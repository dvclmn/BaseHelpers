//
//  Model+UserProvided.swift
//  Networking
//
//  Created by Dave Coleman on 3/3/2025.
//

//import Foundation
//import KeychainSwift
//
//public protocol BYOKeyAuthenticatable: APIKeyAuthenticatable {
//  associatedtype ConfirmationDTO: Decodable
////  associatedtype EndPoint: APIEndpoint where EndPoint.ResponseType == ConfirmationDTO
//  func saveKey(_ secret: String) -> Bool
//  func getKey() throws -> String
//  func checkHasKey() -> Bool
//  func removeKey() -> Bool
//  
//  var confirmationEndpoint: String { get }
//  func testConnection(withKey: String) async throws
//  func extractConfirmation(fromDTO dto: ConfirmationDTO) -> Bool
//  var keychain: KeychainSwift { get }
//}



//public protocol UserProvidedAPIKey where Self: APIKeyAuthenticatable, Metadata: ServiceMetadata {
  
//  associatedtype ConfirmationDTO: Decodable & Sendable

//  var auth: Authenticator { get }
//  var serviceMetadata: Metadata { get }
//  func saveKey(_ secret: String) -> Bool
//  func getKey() throws -> String
//  func checkHasKey() -> Bool
//  func removeKey() -> Bool
//  
//  var confirmationEndpoint: String { get }
//  func testConnection(withKey: String) async throws
//  func extractConfirmation(fromDTO dto: ConfirmationDTO) -> Bool
//  var keychain: KeychainSwift { get }
//}

//public struct BYOKeyConfirmationEndpoint<Response: Decodable>: APIEndpoint {
//  
//  public typealias ResponseType = Response
////  public var responseType: Response.Type { Response.self }
//  
//  public var requiresBody: Bool { false }
//  
////  typealias RequestBodyType = AnthropicDTO.MessageBody
//  
//  public let url: RequestURL
//  public let method = RequestMethod.get
////  public let defaultHeaders: [APIHeader]
//}

//extension BYOKeyAuthenticatable {
//  
//  @MainActor
//  public func testConnection(withKey key: String) async throws {
//    print("Testing connection for provider \(metadata.name)...")
//    
//    let endpoint = BYOKeyConfirmationEndpoint<ConfirmationDTO>(
//      url: RequestURL(confirmationEndpoint),
////      defaultHeaders: []
//    )
//
//    let request = APIRequestNoBody<BYOKeyConfirmationEndpoint>(
//      endpoint: endpoint,
//      authenticator: self,
////      additionalHeaders: [],
//      secret: key
//    )
//    let response = try await request.fetch()
//    
//    guard extractConfirmation(fromDTO: response) else {
//      throw ConfirmationError.confirmationMetricNotFound
//    }
//  }  // END open ai test
//  
//  @discardableResult
//  public func removeKey() -> Bool {
//    guard keychain.delete(Self.key) else {
//      return false
////      throw AuthError.keychainDeleteFailed
//    }
//    return true
//  }
//
//  /// There may be a better way, but if this method *doesn't* throw,
//  /// then I will use that as the metric of success, and elsewhere
//  /// update the ``BYOKeyAuthenticatable/isConnected`` property
//  public func saveKey(_ secret: String) -> Bool {
//    print("Saving string to Keychain, using key: \(Self.key)")
//    guard keychain.set(secret, forKey: Self.key) else {
//      print("String did not save to Keychain.")
//      return false
////      throw AuthError.keychainSaveFailed
//    }
//    print("String saved to Keychain successfully")
//    return true
//    //#warning("Need to figure out a reliable way to establish connected status, mutating the struct, not hitting the keychain more than neccesary, etc")
//  }
//
//  public func getKey() throws -> String {
//    guard let key = keychain.get(Self.key) else {
//      throw AuthError.keychainSaveFailed
//    }
//    return key
//  }
//
//  public func checkHasKey() -> Bool {
//    print("Checking if value for key \(Self.key) exists in Keychain")
//    guard keychain.get(Self.key) != nil else {
//      print("Key was not found in Keychain")
//      return false
//    }
//    print("Key was found in Keychain 👍")
//    return true
//  }
//
//}
//
//public enum ConfirmationError: Error, LocalizedError {
//  case confirmationMetricNotFound
//}
