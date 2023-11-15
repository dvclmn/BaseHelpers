//
//  APIResponseHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation

struct APIResponseHandler: Codable {
    struct Choice: Codable {
        let text: String
    }
    
    let choices: [Choice]
}
