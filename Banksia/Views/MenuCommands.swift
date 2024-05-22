//
//  MenuHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 7/2/2024.
//

import Foundation
import SwiftUI

struct MenuCommands: Commands {

    @Binding var bk: BanksiaHandler
    @Binding var conv: ConversationHandler
    
    
    var body: some Commands {
        
        CommandGroup(replacing: .newItem) {
            Button("New Conversation…") {
                conv.isRequestingNewConversation = true
            }
            .keyboardShortcut("n", modifiers: .command)
            
            Button("Open Conversation…") {
                bk.isQuickNavShowing.toggle()
            }
            .keyboardShortcut("o", modifiers: .command)
            
            Button("Edit Conversation…") {
                conv.isConversationEditorShowing.toggle()
            }
            .keyboardShortcut("e", modifiers: .command)
            
            Button("Delete Conversation…") {
                
            }
            .keyboardShortcut(.delete, modifiers: .command)
            
        }
        
//        ToolbarCommands()
        InspectorCommands()
    }
}
