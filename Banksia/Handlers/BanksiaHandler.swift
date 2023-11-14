//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI

@Observable
class BanksiaHandler {
    var selectedConversation: Conversation?
    var columnVisibility: NavigationSplitViewVisibility
    
    var sidebarTitle = "Conversation"
    
    
    init(
        selectedConversation: Conversation? = nil,
         columnVisibility: NavigationSplitViewVisibility = .automatic
    ) {
        self.selectedConversation = selectedConversation
        self.columnVisibility = columnVisibility
    }
}

