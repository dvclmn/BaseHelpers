//
//  NavHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI

@Observable
class NavHandler {
    var selectedAnimalCategoryName: String?
    var selectedConversation: Conversation?
    var columnVisibility: NavigationSplitViewVisibility
    
    var sidebarTitle = "Conversation"
    
//    var contentListTitle: String {
//        if let selectedAnimalCategoryName {
//            selectedAnimalCategoryName
//        } else {
//            ""
//        }
//    }
    
    init(
        selectedConversation: Conversation? = nil,
         columnVisibility: NavigationSplitViewVisibility = .automatic
    ) {
        self.selectedConversation = selectedConversation
        self.columnVisibility = columnVisibility
    }
}

