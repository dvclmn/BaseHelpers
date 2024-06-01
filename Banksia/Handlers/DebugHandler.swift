//
//  DebugHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 1/6/2024.
//

import Foundation
import SwiftUI


struct DebugRow: Identifiable {
    var id = UUID()
    var title: String
    var state: DebugState
    var definedOn: DefinedOn
}

struct DebugState {
    var main: String
    var log: [String] = []
}

struct RowHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        for (index, height) in nextValue() {
            value[index] = max(value[index] ?? 0, height)
        }
    }
}

enum DebugColumn: String, CaseIterable {
    case title = "Title"
    case state = "State"
    case definedOn = "Defined on"
    
    var columnPosition: ColumnPosition {
        switch self {
        case .title:
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

enum ColumnPosition {
    case beginning
    case middle
    case end
}

