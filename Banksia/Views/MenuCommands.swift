//
//  MenuHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 7/2/2024.
//

import Foundation
import SwiftUI
import Sidebar
import GeneralStyles
import Sparkle

struct MenuCommands: Commands {
    
    @ObservedObject var bk: BanksiaHandler
    @ObservedObject var conv: ConversationHandler
    @ObservedObject var sidebar: SidebarHandler
    
    let updaterController: SPUStandardUpdaterController
    
    var body: some Commands {
        
        CommandGroup(replacing: .newItem) {
            Button(AppAction.new.name) {
                conv.currentRequest = .new
            }
            .keyboardShortcut(AppAction.new.shortcut)
            
            
            Button(AppAction.toggleQuickOpen.name) {
                conv.currentRequest = .toggleQuickOpen
            }
            .keyboardShortcut(AppAction.toggleQuickOpen.shortcut)
            
            
            Button(AppAction.edit.name) {
                conv.isConversationEditorShowing.toggle()
            }
            .keyboardShortcut(AppAction.edit.shortcut)
            
            
            Button(AppAction.exportAll.name) {
                conv.currentRequest = .exportAll
            }
            .keyboardShortcut(AppAction.exportAll.shortcut)
        }
        
        
        // MARK: - View
        CommandGroup(before: .toolbar) {
            Button(sidebar.isSidebarDismissed ? "Show Sidebar" : "Hide Sidebar") {
                conv.currentRequest = .toggleSidebar
            }
            .keyboardShortcut(AppAction.toggleSidebar.shortcut)
            
            Button(bk.isToolbarExpanded ? "Hide Expanded Toolbar" : "Show Expanded Toolbar") {
                conv.currentRequest = .toggleToolbarExpanded
            }
            .keyboardShortcut(AppAction.toggleToolbarExpanded.shortcut)
            
            Button(bk.isDebugShowing ? "Hide Debug Window" : "Show Debug Window") {
                conv.currentRequest = .toggleDebug
            }
            .keyboardShortcut(AppAction.toggleDebug.shortcut)
            
        }
        
        CommandMenu("Conversation") {

            Button(AppAction.sendQuery.name) {
                conv.currentRequest = .sendQuery
            }
            .keyboardShortcut(AppAction.sendQuery.shortcut)
            .disabled(conv.userPrompt.isEmpty)
            
            
            Button(AppAction.goToPrevious.name) {
                conv.currentRequest = .goToPrevious
            }
            .keyboardShortcut(AppAction.goToPrevious.shortcut)
            
            Button(AppAction.goToNext.name) {
                conv.currentRequest = .goToNext
            }
            .keyboardShortcut(AppAction.goToNext.shortcut)
            
            Divider()
            
//            Button("Previous Quick Open Conversation") {
//                conv.currentRequest = .goToPreviousQuickOpen
//            }
//            .disabled(!bk.isPreviousQuickOpenAvailable && !bk.isQuickOpenShowing)
//            .keyboardShortcut(.upArrow, modifiers: [])
//            
//            Button("Next Quick Open Conversation") {
//                conv.currentRequest = .goToNextQuickOpen
//            }
//            .disabled(!bk.isNextQuickOpenAvailable && !bk.isQuickOpenShowing)
//            .keyboardShortcut(.downArrow, modifiers: [])
            
            
        }
        CommandGroup(after: .pasteboard) {
            
                Button("Delete Conversation…") {
                    conv.currentRequest = .delete
                }
                .disabled(conv.isEditorFocused && conv.currentConversationID == nil)
//                .keyboardShortcut(.delete, modifiers: .command)
            
        }
        
        CommandGroup(before: .textEditing) {
            Button(AppAction.search.name) {
                conv.currentRequest = .search
            }
            .keyboardShortcut(AppAction.search.shortcut)
        }
        
        
        CommandGroup(after: .appInfo) {
            CheckForUpdatesView(updater: updaterController.updater)
        }
        
        //        ToolbarCommands()
        //        InspectorCommands()
    }
}
