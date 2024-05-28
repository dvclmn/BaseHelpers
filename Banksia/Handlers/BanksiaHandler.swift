//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import Navigation
import GeneralStyles

@Observable
class BanksiaHandler {

    var isQuickOpenShowing: Bool = false
    
    var isRequestingNextQuickOpenItem: Bool = false
    var isRequestingPreviousQuickOpenItem: Bool = false
    
    var isNextQuickOpenAvailable: Bool = false
    var isPreviousQuickOpenAvailable: Bool = false

    var isGlobalConversationPreferencesShowing: Bool = false
    var isEditingLongFormText: Bool = false
    
    func toggleQuickOpen() {
        withAnimation(Styles.animation) {
            if isQuickOpenShowing {
                withAnimation(Styles.animation) {
                    isQuickOpenShowing = false
                }
            } else {
                withAnimation(Styles.animationQuick) {
                    isQuickOpenShowing = true
                }
            }
        }
    } // END toggle quick open
    

    
}


