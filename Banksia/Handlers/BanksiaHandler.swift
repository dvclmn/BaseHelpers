//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import Navigation
import Styles

@Observable
class BanksiaHandler {
    
    let pref = Preferences()
    
    var selectedConversation: Conversation.ID? = nil
    
    var totalConversations: Int = 0
    
    var uiDimming: Double = 0.25

    var isQuickNavShowing: Bool = false
    
    var isGlobalConversationPreferencesShowing: Bool = false
    var isEditingLongFormText: Bool = false
    
}


