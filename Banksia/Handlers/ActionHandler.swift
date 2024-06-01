//
//  ActionHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 1/6/2024.
//

import Foundation
import SwiftUI

enum AppAction {
    case new
    case edit
    case delete
    
    case sendQuery
    
    case exportAll
    case goToPrevious
    case goToNext
    case search
    case toggleQuickOpen
    case toggleSidebar
    case toggleToolbarExpanded
    case toggleDebug
    
    case goToPreviousQuickOpen
    case goToNextQuickOpen
    
    case none
    
    var name: String {
        switch self {
        case .new:
            return "New"
        case .edit:
            return "Edit"
        case .delete:
            return "Delete"
            
        case .sendQuery:
            return "Send"
            
        case .exportAll:
            return "Export All…"
            
        case .goToPrevious:
            return "Previous Conversation"
        case .goToNext:
            return "Next Conversation"
            
        case .search:
            return "Search"
        case .toggleQuickOpen:
            return "Quick Open"
        case .toggleSidebar:
            return "Toggle Sidebar"
            
        case .toggleToolbarExpanded:
            return "Toggle Expanded toolbar"
            
        case .toggleDebug:
            return "Toggle Debug Window"
            
        case .goToPreviousQuickOpen:
            return "Go To Previous Quick Open"
        case .goToNextQuickOpen:
            return "Go To Next Quick Open"
        case .none:
            return "None"
        }
    }
    
    
    var shortcut: KeyboardShortcut {
        switch self {
        case .new:
                .init("n", modifiers: .command)
        case .edit:
                .init("e", modifiers: .command)
        case .delete:
                .init(.delete, modifiers: .command)
            
        case .sendQuery:
                .init(.return, modifiers: .command)
            
        case .exportAll:
                .init("e", modifiers: [.command, .shift])
            
            
        case .goToPrevious:
                .init("[", modifiers: [.command, .shift])
            
        case .goToNext:
                .init("]", modifiers: [.command, .shift])
            
        case .search:
                .init("f", modifiers: .command)
        case .toggleQuickOpen:
                .init("o", modifiers: .command)
        case .toggleSidebar:
                .init("\\", modifiers: .command)
            
        case .toggleToolbarExpanded:
                .init("i", modifiers: .command)
            
        case .toggleDebug:
                .init("d", modifiers: .shift)
            
        case .goToPreviousQuickOpen:
                .init(.upArrow, modifiers: [])
        case .goToNextQuickOpen:
                .init(.downArrow, modifiers: [])
        case .none:
                .defaultAction
        }
    }

}
