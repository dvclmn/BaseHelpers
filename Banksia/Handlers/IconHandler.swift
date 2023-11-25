//
//  IconHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 21/11/2023.
//

import Foundation

struct ConversationIcon: Hashable, Decodable {
    
    var name: String
    var favourite: Bool = false
    var category: IconCategory
    var searchTerms: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case searchTerms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(IconCategory.self, forKey: .category)
        searchTerms = try container.decode([String].self, forKey: .searchTerms)
    }
    
} // END ConversationIcon

extension BanksiaHandler {
    func loadIcons() -> [ConversationIcon] {
        var icons: [ConversationIcon] = []
        // Assuming you have a `banksia_icons.json` file in your main bundle
        if let url = Bundle.main.url(forResource: "banksia_icons", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoder = JSONDecoder()
                icons = try decoder.decode([ConversationIcon].self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } // END try data
        return icons
    } // END func load icons
} // END banksia handler

enum IconCategory: String, CaseIterable, Decodable {
    case general
    case technology
    case nature
    case objects
    case fitness
    case productivity
    case shapes
    case symbols
    case creativity
    case transport
    
    var icon: String {
        switch self {
        case .general:
            return "rays"
        case .technology:
            return "qrcode"
        case .nature:
            return "fish"
        case .objects:
            return "hanger"
        case .fitness:
            return "figure.basketball"
        case .productivity:
            return "paperclip"
        case .shapes:
            return "pentagon"
        case .symbols:
            return "command"
        case .creativity:
            return "theatermasks"
        case .transport:
            return "ferry"
        }
    }
}
