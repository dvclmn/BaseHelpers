//
//  AnyRequestComponent.swift
//  Networking
//
//  Created by Dave Coleman on 3/3/2025.
//

//import Foundation

///// Non-generic base protocol
//public protocol AnyAPIRequestComponent {
//  func applyToAny<T: Decodable>(request: inout APIRequest<T>)
//}
//
///// Generic protocol that refines the base protocol
//public protocol APIRequestComponent<T>: AnyAPIRequestComponent {
//  associatedtype T: Decodable
//  func apply(to request: inout APIRequest<T>)
//}
//
///// Default implementation to bridge the two
//extension APIRequestComponent {
//  public func applyToAny<U: Decodable>(request: inout APIRequest<U>) {
//    /// Only apply if the types match
//    if let request = request as? APIRequest<T> {
//      var typedRequest = request
//      apply(to: &typedRequest)
//      request = typedRequest as! APIRequest<U>
//    }
//  }
//}
