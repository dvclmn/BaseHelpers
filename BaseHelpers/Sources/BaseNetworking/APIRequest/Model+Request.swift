//
//  Model+Request.swift
//  Networking
//
//  Created by Dave Coleman on 18/2/2025.
//

//import Foundation
//import MemberwiseInit

/// ```
/// let loginRequest = APIRequestNoBody(
///   endpoint: endpoint,
///   authenticator: authenticator,
///   additionalHeaders: [],
///   secret: code
/// )
///
/// let postRequest = APIRequestWithBody(
///   endpoint: endpoint,
///   authenticator: authenticator,
///   additionalHeaders: [],
///   body: someCodableThing,
///   secret: code
/// )
///
/// let response = try await postRequest.fetch()
///
/// ```


//public protocol APIRequestable: Sendable {
//  associatedtype Endpoint: APIEndpoint
//  var endpoint: Endpoint { get }
//  var authenticator: (any Authenticatable)? { get }
//  var additionalHeaders: [APIHeader] { get }
//  var secret: String? { get }
//
//  /// Optional body for polymorphic encoding
//  var _body: (any Encodable)? { get }
//}
//
//extension APIRequestable {
//  
//  public var additionalHeaders: [APIHeader] { [] }
//  
////  public var headers: [APIHeader] {
////    var all = endpoint.defaultHeaders
////    all.append(contentsOf: additionalHeaders)
////    return all
////  }
//
//  public func buildURLRequest() throws -> URLRequest {
//    try APIHandler.createRequest(
//      url: endpoint.url.buildURL(),
//      method: endpoint.method,
//      body: _body,
//      headers: additionalHeaders.toDictionary(with: secret)
//    )
//  }
//
//  public func fetch() async throws -> Endpoint.ResponseType {
//    var request = try buildURLRequest()
//
//    if let authenticator {
//      try await authenticator.authenticate(&request, with: secret)
//    } else {
//      print("No authenticator provided. Skipping authentication.")
//    }
//
//    return try await APIHandler.fetch(request: request)
//  }
//}

// MARK: - Concrete Types

//public struct APIRequestWithBody<E: APIEndpoint, B: Encodable>: APIRequestable {
//  public let endpoint: E
//  public let authenticator: (any Authenticatable)?
//  public let additionalHeaders: [APIHeader]
//  public let body: B
//  public let secret: String?
//
//  public var _body: (any RequestBody)? { body }
//  
//  public init(
//    endpoint: E,
//    authenticator: (any Authenticatable)?,
//    additionalHeaders: [APIHeader] = [],
//    body: B,
//    secret: String?
//  ) {
//    self.endpoint = endpoint
//    self.authenticator = authenticator
//    self.additionalHeaders = additionalHeaders
//    self.body = body
//    self.secret = secret
//  }
//}

//public struct APIRequestNoBody<E: APIEndpoint>: APIRequestable {
//  public let endpoint: E
//  public let authenticator: (any Authenticatable)?
//  
//  /// This is for any headers not relating to Authorisaiton,
//  /// which are already handled elsewhere
//  public let additionalHeaders: [APIHeader]
//  public let secret: String?
//
//  public var _body: (any RequestBody)? { nil }
//  
//  public init(
//    endpoint: E,
//    authenticator: (any Authenticatable)?,
//    additionalHeaders: [APIHeader] = [],
//    secret: String?
//  ) {
//    self.endpoint = endpoint
//    self.authenticator = authenticator
//    self.additionalHeaders = additionalHeaders
//    self.secret = secret
//  }
//}

/// Another option:
///
/// ```
/// public enum APIRequest<E: APIEndpoint>: Sendable {
///   case withBody(APIRequestWithBody<E, any Encodable & Sendable>)
///   case noBody(APIRequestNoBody<E>)
///
///   public func fetch() async throws -> E.ResponseType {
///     switch self {
///       case .withBody(let req): return try await req.fetch()
///       case .noBody(let req): return try await req.fetch()
///     }
///   }
/// }
/// ```

//public protocol APIRequestable: Sendable {
//  associatedtype Endpoint: APIEndpoint
//  var endpoint: Endpoint { get }
//  var authenticator: (any Authenticatable)? { get }
//  var additionalHeaders: [APIHeader] { get }
//  var secret: String? { get }
//}
//
//public protocol BodyAPIRequesting: APIRequestable {
//  associatedtype Body: Encodable & Sendable
//  var body: Body { get }
//}
//
//public struct APIRequestWithBody<E: APIEndpoint, B: Encodable & Sendable>: BodyAPIRequesting {
//  public let endpoint: E
//  public let authenticator: (any Authenticatable)?
//  public let additionalHeaders: [APIHeader]
//  public let body: B
//  public let secret: String?
//}
//
//public struct APIRequestNoBody<E: APIEndpoint>: APIRequestable {
//  public let endpoint: E
//  public let authenticator: (any Authenticatable)?
//  public let additionalHeaders: [APIHeader]
//  public let secret: String?
//}


//public struct APIRequest<E: APIEndpoint, Body: Encodable & Sendable>: Sendable {
//
//  /// The endpoint contains the response type, URL, method, default headers
//  private let endpoint: E
//
//  /// These can customize or override endpoint defaults
//  public var authenticator: (any Authenticatable)?
//  public var additionalHeaders: [APIHeader]
//  public var body: Body?
//  public var secret: String?
//
//  public init(
//    endpoint: E,
//    authenticator: (any Authenticatable)? = nil,
//    additionalHeaders: [APIHeader] = [],
//    body: Body?,
//    secret: String? = nil,
//  ) {
//    self.endpoint = endpoint
//    self.body = body
//    self.authenticator = authenticator
//    self.additionalHeaders = additionalHeaders
//    self.secret = secret
//  }
//
//}
//public struct APIRequest<T: Decodable & Sendable> {
//  public var authenticator: (any Authenticatable)?
//  public var url: RequestURL
//  public var requestMethod: RequestMethod
//  public var headers: [APIHeader]
//  public var body: (any Encodable)?
//#warning("The goal ultimately, is to remove `secret`, as this is ONLY here to accomodate GOG and BYO API keys. This should be handled at the authentication level, with a defined strategy, not here in the APIRequest model.")
//  public var secret: String?
//
//  public init(
//    authenticator: (any Authenticatable)?,
//    url: RequestURL,
//    requestMethod: RequestMethod = .get,
//    headers: [APIHeader] = [],
//    body: (any Encodable)? = nil,
//    secret: String? = nil
//  ) {
//    self.authenticator = authenticator
//    self.url = url
//    self.requestMethod = requestMethod
//    self.headers = headers
//    self.body = body
//    self.secret = secret
//  }
//}

#warning("Will possibly be useful once result builder is set up")
//extension APIRequest {
//  public init(@APIRequestBuilder _ components: () -> [APIRequestComponent<T>]) throws {
//    self.init(
//      authenticator: nil,
//      url: RequestURL(host: "", endpoint: ""),  // Default empty URL that will be overridden
//      requestMethod: .get,  // Default method
//      headers: [],
//      body: nil,
//      secret: nil
//    )
//
//    // Apply all components
//    var mutableSelf = self
//    for component in components() {
//      component.apply(to: &mutableSelf)
//    }
//
//    // Validate required fields
//    guard mutableSelf.url.buildURL() != nil else {
//      throw APIError.invalidURL
//    }
//
//    self = mutableSelf
//  }
//}


//extension APIRequest {

//  var headers: [APIHeader] {
//    var allHeaders: [APIHeader] = []
//    allHeaders.append(contentsOf: endpoint.defaultHeaders)
//    allHeaders.append(contentsOf: additionalHeaders)
//
//    return allHeaders
//  }
//
//  public func buildURLRequest() throws -> URLRequest {
//
//    print("Building `URLRequest` from `APIRequest<\(E.self)>`")
//
//    var request = try APIHandler.createRequest(
//      url: endpoint.url.buildURL(),
//      method: endpoint.method,
//      body: body,
//      headers: headers.toDictionary(with: secret)
//    )
//
//    return request
//  }
  //  }

  //  @MainActor
//  public func fetch() async throws -> E.ResponseType {
//    print("Running fetch operation for `APIRequest`, with type `\(E.self)`")
//
//    var request: URLRequest = try buildURLRequest()
//
//    if !headers.isEmpty {
//      print(
//        "Some headers found before request authentication. Checking they are still present after authentication. Headers: \(headers)"
//      )
//    }
//
//    if let authenticator {
//      print("Authenticating `APIRequest`...")
//      try await authenticator.authenticate(&request, with: secret)
//      print("Authentication of URLRequest was successful. Updated request:\n\(request.debugString)")
//    } else {
//      print("No authenticator provided. Skipping authentication.")
//    }
//    print("Now ready to fetch a response using this `APIRequest`.")
//
//    let result: E.ResponseType = try await APIHandler.fetch(request: request)
//
//    print("Fetch was successful, returning result.")
//
//    return result
//  }
//
//}
