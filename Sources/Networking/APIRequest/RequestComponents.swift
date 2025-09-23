//
//  RequestComponents.swift
//  Networking
//
//  Created by Dave Coleman on 3/3/2025.
//

//import Foundation
//
//public struct DTOComponent<T: Decodable>: APIRequestComponent {
//  private let type: T.Type
//  
//  public init(_ type: T.Type) {
//    self.type = type
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    // Nothing to do, just establishes the type
//  }
//}
//
//public struct AuthenticatorComponent<T: Decodable>: APIRequestComponent {
//  private let authenticator: any Authenticatable
//  
//  public init(_ authenticator: any Authenticatable) {
//    self.authenticator = authenticator
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.authenticator = authenticator
//  }
//}
//
//public struct SecretComponent<T: Decodable>: APIRequestComponent {
//  private let secret: String
//  
//  public init(_ secret: String) {
//    self.secret = secret
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.secret = secret
//  }
//}
//
//public struct URLComponent<T: Decodable>: APIRequestComponent {
//  private let url: RequestURL
//  
//  public init(_ url: RequestURL) {
//    self.url = url
//  }
//  
//  public init(_ urlString: String) {
//    self.url = RequestURL(urlString)
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.url = url
//  }
//}
//
//public struct MethodComponent<T: Decodable>: APIRequestComponent {
//  private let method: RequestMethod
//  
//  public init(_ method: RequestMethod) {
//    self.method = method
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.requestMethod = method
//  }
//}
//
//public struct HeaderComponent<T: Decodable>: APIRequestComponent {
//  private let header: APIHeader
//  
//  public init(_ key: String, _ value: String) {
//    self.header = APIHeader(key: key, value: value)
//  }
//  
//  public init(_ header: APIHeader) {
//    self.header = header
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.headers.append(header)
//  }
//}
//
//public struct HeadersComponent<T: Decodable>: APIRequestComponent {
//  private let headers: [APIHeader]
//  
//  public init(_ headers: [APIHeader]) {
//    self.headers = headers
//  }
//  
//  public init(@HeadersBuilder _ builder: () -> [APIHeader]) {
//    self.headers = builder()
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.headers.append(contentsOf: headers)
//  }
//}
//
//public struct BodyComponent<T: Decodable>: APIRequestComponent {
//  private let body: any Encodable
//  
//  public init(_ body: any Encodable) {
//    self.body = body
//  }
//  
//  public func apply(to request: inout APIRequest<T>) {
//    request.body = body
//  }
//}
