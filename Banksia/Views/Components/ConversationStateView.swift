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
    
//    var emoji: String
//    var title: String
//    var message: String
//    var actionLabel: String?
//    var actionIcon: String?
//    var action: (() -> Void)?
    
    var body: some View {
  EmptyView()
        Text("No conversation selected")
//        switch bk.selectionState {
//        case .blank:
//            Text("No conversations created at all")
//        case .single:
//            EmptyView()
//        case .multiple:
//            VStack(alignment: .center) {
//                Text(bk.selectionState.randomEmoji())
//                    .font(.title)
//                    .padding(.bottom,6)
//                Text(bk.selectionState.randomTitle())
//                    .font(.title)
//                    .opacity(0.8)
//                    .padding(.bottom,4)
//                Text(bk.selectionState.randomMessage())
//                    .opacity(0.4)
//                    .padding(.bottom,14)
////                if let action = action, let actionLabel = actionLabel, let actionIcon = actionIcon {
////                    
////                    HandyButton(label: actionLabel, icon: actionIcon, action: action)
////                } // END actions check
//            }
//            .padding(.bottom,40)
//        case .none:
//            Text("None selected")
//        }
        
        
        
        
    }
}

#Preview {
    ConversationStateView()
        .environment(BanksiaHandler())
}
