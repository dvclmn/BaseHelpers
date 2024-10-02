//
//  Clipboard.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//
import Foundation
import SwiftUI
import KeychainSwift

//class TokenHandler {
//    
//    let keychain = KeychainSwift()
//    
//    
//    @MainActor func checkKeychainForAuthToken<T: TokenBasedAPI>(for service: T) -> String? {
//        
//        if let token = keychain.get(service.tokenStorageKey) {
//            print("\(service.name) access token found")
//            return token
//        } else {
//            print("No \(service.name) token found")
//            return nil
//        }
//    } // END check keychain for token
//    
//    
//    func requestNewAuthToken<T: TokenBasedAPI>(for service: T) async -> T.TokenData? {
//        
//        print("About to request new \(service.name) token. This should only run if existing token was not found in keychain, or if found, was NOT valid.")
//        
//        do {
//            let request = try APIHandler.constructURLRequest(
//                from: service.authURL(),
//                requestType: service.requestType,
//                clientID: service.clientID,
//                bearerToken: service.tokenData?.token
//            )
//            
//            let decoder = JSONDecoder()
//            
//            let data = try await APIHandler.fetch(request: request)
//            return try decoder.decode(T.TokenData.self, from: data)
//
//        } catch {
//            print("Error requesting token \(service.name): \(error)")
//            return nil
//        }
//    } // END request new token
//    
////    func saveTokenToKeychain(token: ) {
////        
////    }
//    
//}
