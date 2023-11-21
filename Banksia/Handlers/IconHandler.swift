//
//  IconHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 21/11/2023.
//

import Foundation

struct ConversationIcon: Hashable {
    
    let name: String
    let favourite: Bool = false
    let category: IconCategory
    let searchTerms: [String]
}

enum IconCategory: String, CaseIterable {
    case transport
    case sportAndFitness
    case basicShapes
    case creatures
    case productivity
    case tech
    case creativity
}

extension ConversationIcon {
    
    static let icons: [ConversationIcon] = [
        ConversationIcon(
            name: "square.and.arrow.down",
            category: .basicShapes,
            searchTerms: ["square", "arrow", "download"]
        ),
        ConversationIcon(
            name: "pencil",
            category: .productivity,
            searchTerms: ["pencil", "write", "edit"]
        )
    ]
} // END ConversationIcon extension


