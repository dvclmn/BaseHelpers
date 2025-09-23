//
//  Model+Endpoint.swift
//  Networking
//
//  Created by Dave Coleman on 12/3/2025.
//


import Foundation

//public protocol APIEndpoint: Sendable {
//  
//  associatedtype ResponseType: Decodable
////  associatedtype RequestBodyType: Encodable
//  
//  var url: RequestURL { get }
//  var method: RequestMethod { get }
////  var defaultHeaders: [APIHeader] { get }
////  var responseType: ResponseType.Type { get }
//  
//  /// Optional hint about body requirements
//  var requiresBody: Bool { get }
//  
//  /// Optional method to validate request before sending
////#warning("This seems like a good idea, consider implementing properly. Notes in Bear")
//  //  func validate() throws
//
//}

// Consider adding these
//  var queryParameters: [String: String]? { get }
//  var timeout: TimeInterval { get }
//  var cachePolicy: URLRequest.CachePolicy { get }

//protocol PostEndpoint: APIEndpoint {
//  associatedtype Body: Encodable & Sendable
//  
//  static var path: String { get }
//  static func make(
//    body: Body?,
//    auth: (any Authenticatable)?,
//    headers: [APIHeader]
//  ) -> APIRequest<Self, Body>
//}
