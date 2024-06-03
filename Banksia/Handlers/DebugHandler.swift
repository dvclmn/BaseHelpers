//
//  DebugHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 1/6/2024.
//

import Foundation
import SwiftUI
import Table

struct DebugState {
    var main: String
    var log: [String] = []
}

//
//struct DebugRow: Identifiable, Rowable {
//    var id = UUID()
//    var content: [String : Any]
//    
//    init(title: String, state: DebugState, definedOn: DefinedOn) {
//            self.content = [
//                "title": title,
//                "state": state,
//                "definedOn": definedOn
//            ]
//        }
//}




enum DebugColumn: CaseIterable, Columnable {
    
    case label
    case state
    case definedOn
    
    var id: String {
        self.title
    }
    
    var title: String {
        switch self {
        case .label:
            "Title"
        case .state:
            "State"
        case .definedOn:
            "Defined On"
        }
    }
    var position: ColumnPosition {
        switch self {
        case .label:
                .beginning
        case .state:
                .middle
        case .definedOn:
                .end
        }
    }

}

enum DefinedOn: String {
    case conv = "ConversationHandler"
    case sidebar = "SidebarHandler"
    case bk = "BanksiaHandler"
    case nav = "NavigationHandler"
}

