//
//  Model+Service.swift
//  Networking
//
//  Created by Dave Coleman on 2/3/2025.
//


/// A service should define a variety of non-negotiables about itself;
/// relevant DTO's, endpoints, auth methods etc for different purposes.
public protocol APIService {
  
  associatedtype Authenticator: Authenticatable
  associatedtype Metadata: APIServiceMetadata
  
  var auth: Authenticator { get }
  var metadata: Metadata { get }

}

/// This is typically an enum, helpful for UI purposes, and
/// handling static information about the Service.
///
/// This often mirrors the concrete structs that are involved
/// in the particular domain, as cases rather than objects
///
/// E.g. `Steam`, `GOG` etc would be both structs, and also
/// `case steam, gog` in the metadata enum.
public protocol APIServiceMetadata: Identifiable, CaseIterable, Equatable, Sendable {
  var id: ID { get }
  var name: String { get }
}
