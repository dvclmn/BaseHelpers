//
//  Clipboard.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//
//import Foundation
//import SwiftUI
//import APIHandler
//import BaseHelpers
//
//public protocol TokenBasedAPI {
//    
//    associatedtype TokenData: TokenResponse
//    
//    var name: String { get }
//    
//    var tokenStorageKey: String { get }
//    var requestType: APIRequestType { get }
//    var clientID: String? { get }
//    var clientSecret: String? { get }
//    var tokenData: TokenData? { get set }
//    
//    func authURL() -> URL?
//}
//
//public protocol LoginTokenAPI: TokenBasedAPI {
//    var loginCode: String { get }
//}
//
//public protocol RefreshableTokenAPI: TokenBasedAPI {
//    var refreshURL: URL? { get }
//    var refreshTokenStorageKey: String { get }
//}
//
//public protocol TimedTokenAPI: TokenBasedAPI {
//    
//    var expiresIn: TimeInterval { get }
//    var countdownTimer: CountdownTimer { get set }
//    
//}
//
//public protocol CheckableTokenAPI: TokenBasedAPI {
//    associatedtype TokenCheckData: TokenCheckResponse
//    
//    var tokenCheckData: TokenCheckData? { get set }
//    var tokenCheckURL: URL? { get }
//}
//
//
///// Response protocols (DTO)
//public protocol TokenResponse: Codable {
//    var token: String { get }
//    var expiresIn: Int { get }
//}
//
//public protocol TokenCheckResponse: Codable {
//    var expiresIn: Int? { get }
//}
//
//
//enum TokenExpiryStatus {
//    case shouldRefresh
//    case expired
//    
//    var buffer: TimeInterval {
//        switch self {
//        case .expired:
//            return 0
//        case .shouldRefresh:
//            return 120
//        }
//    } // END buffer
//    
//    static func status(forRemainingTime remainingTime: TimeInterval) -> TokenExpiryStatus {
//        if remainingTime <= TokenExpiryStatus.expired.buffer {
//            return .expired
//        } else if remainingTime <= TokenExpiryStatus.shouldRefresh.buffer {
//            return .shouldRefresh
//        } else {
//            return .expired
//        }
//    } // END status
//}
//
