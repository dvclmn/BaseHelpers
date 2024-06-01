//
//  ActionHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 1/6/2024.
//

import Foundation
import SwiftUI

enum AppFocus: String {
    case search
//    case sidebar
    case editor
    case toolbarExpanded
    case quickOpen
    case none
    
    var name: String {
        self.rawValue
    }
}


enum AppAction {
    case new
    case delete
    
    case conversationSettings

    case sendQuery
    
    case exportConversation
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
        case .conversationSettings:
            return "Conversation Settings…"
        case .delete:
            return "Delete"
            
        case .sendQuery:
            return "Send"
            
        case .exportConversation:
            return "Export Conversation…"
            
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
    
    var focus: AppFocus {
        switch self {
        case .sendQuery, .goToPrevious, .goToNext:
                .editor
            
        case .search:
                .search
        case .toggleQuickOpen, .goToPreviousQuickOpen, .goToNextQuickOpen:
                .quickOpen
            
        case .toggleToolbarExpanded:
                .toolbarExpanded
            
        default:
                .none
        }
    }
    
    
    var shortcut: KeyboardShortcut {
        switch self {
        case .new:
                .init("n", modifiers: .command)
        case .conversationSettings:
                .init("e", modifiers: .command)
        case .delete:
                .init(.delete, modifiers: .command)
            
        case .sendQuery:
                .init(.return, modifiers: .command)
            
        case .exportConversation:
                .init("e", modifiers: [.command])
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
