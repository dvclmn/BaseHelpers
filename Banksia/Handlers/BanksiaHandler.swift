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

enum FocusedArea: Hashable {
    case search
    case sidebar
    case editor
    case toolbarExpanded
}

extension Styles {
    static let paddingGutter: Double = 12
}

class BanksiaHandler: ObservableObject {
    
    @Published var isQuickOpenShowing: Bool = false
    
//    @Published var isRequestingNextQuickOpenItem: Bool = false
//    @Published var isRequestingPreviousQuickOpenItem: Bool = false
//    
//    @Published var isNextQuickOpenAvailable: Bool = false
//    @Published var isPreviousQuickOpenAvailable: Bool = false
    
//    @Published var isGlobalConversationPreferencesShowing: Bool = false
    @Published var isEditingLongFormText: Bool = false
    
    @Published var isToolbarExpanded: Bool = false
    
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
    
    func toggleExpanded() {
        isToolbarExpanded.toggle()
    }
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }
    
    func getBuildNumber() -> String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "Unknown"
    }
    
}


