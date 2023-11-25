//
//  ConversationStateView.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import SwiftUI

struct ConversationStateView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    var emoji: String
    var title: String
    var message: String
    var actionLabel: String?
    var actionIcon: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center) {
            Text(emoji)
                .fontStyle(.largeTitle, size: 48)
                .padding(.bottom,6)
            Text(title)
                .fontStyle(.largeTitle)
                .opacity(0.8)
                .padding(.bottom,4)
            Text(message)
                .fontStyle(.body)
                .opacity(0.4)
                .padding(.bottom,14)
            if let action = action, let actionLabel = actionLabel, let actionIcon = actionIcon {
                
                HandyButton(label: actionLabel, icon: actionIcon, action: action)
            } // END actions check
        }
        .padding(.bottom,40)
        
        
    }
}

#Preview {
    ConversationStateView(emoji: "🕳️", title: "Nothing selected", message: "Make a selection on the left", actionLabel: "New chat", actionIcon: "plus")
        .environment(BanksiaHandler())
}
