//
//  NotionModel.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import Foundation

struct CreatePageRequest: Codable {
    let parent: Parent
    let properties: [String: PropertyValue]
    
    struct Parent: Codable {
        let database_id: String
    }
    
    enum PropertyValue: Codable {
        case title([Text])
        case richText([Text])
        case number(Double)
        case select(Select)
        case multiSelect([Select])
        case date(DateValue)
        case checkbox(Bool)
        case url(String)
        case email(String)
        case phoneNumber(String)
        
        enum CodingKeys: String, CodingKey {
            case title, richText = "rich_text", number, select, multiSelect = "multi_select", date, checkbox, url, email, phoneNumber = "phone_number"
        }
        
        struct Text: Codable {
            let type: String
            let text: TextContent
            
            struct TextContent: Codable {
                let content: String
            }
        }
        
        struct Select: Codable {
            let name: String
        }
        
        struct DateValue: Codable {
            let start: String
            let end: String?
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let title = try? container.decode([Text].self, forKey: .title) {
                self = .title(title)
                return
            }
            if let richText = try? container.decode([Text].self, forKey: .richText) {
                self = .richText(richText)
                return
            }
            if let number = try? container.decode(Double.self, forKey: .number) {
                self = .number(number)
                return
            }
            if let select = try? container.decode(Select.self, forKey: .select) {
                self = .select(select)
                return
            }
            if let multiSelect = try? container.decode([Select].self, forKey: .multiSelect) {
                self = .multiSelect(multiSelect)
                return
            }
            if let date = try? container.decode(DateValue.self, forKey: .date) {
                self = .date(date)
                return
            }
            if let checkbox = try? container.decode(Bool.self, forKey: .checkbox) {
                self = .checkbox(checkbox)
                return
            }
            if let url = try? container.decode(String.self, forKey: .url) {
                self = .url(url)
                return
            }
            if let email = try? container.decode(String.self, forKey: .email) {
                self = .email(email)
                return
            }
            if let phoneNumber = try? container.decode(String.self, forKey: .phoneNumber) {
                self = .phoneNumber(phoneNumber)
                return
            }
            
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode PropertyValue"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .title(let title):
                try container.encode(title, forKey: .title)
            case .richText(let richText):
                try container.encode(richText, forKey: .richText)
            case .number(let number):
                try container.encode(number, forKey: .number)
            case .select(let select):
                try container.encode(select, forKey: .select)
            case .multiSelect(let multiSelect):
                try container.encode(multiSelect, forKey: .multiSelect)
            case .date(let date):
                try container.encode(date, forKey: .date)
            case .checkbox(let checkbox):
                try container.encode(checkbox, forKey: .checkbox)
            case .url(let url):
                try container.encode(url, forKey: .url)
            case .email(let email):
                try container.encode(email, forKey: .email)
            case .phoneNumber(let phoneNumber):
                try container.encode(phoneNumber, forKey: .phoneNumber)
            }
        }
    }
}

