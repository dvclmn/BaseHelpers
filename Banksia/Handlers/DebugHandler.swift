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




enum DebugColumn: String, CaseIterable, Columnable  {
    
    case label = "Title"
    case state = "State"
    case definedOn = "Defined on"
    
    var id: String {
        self.rawValue
    }
    
    var title: String? {
        return self.rawValue
    }
    var minWidth: Double {
        switch self {
        case .label:
            100
        case .state:
            90
        case .definedOn:
            100
        }
    }
    var maxWidth: Double {
        return .infinity
    }

}

enum DefinedOn: String {
    case conv = "ConversationHandler"
    case sidebar = "SidebarHandler"
    case bk = "BanksiaHandler"
    case nav = "NavigationHandler"
}

