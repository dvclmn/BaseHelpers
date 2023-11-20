//
//  ConversationView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData

struct ConversationView: View {
    @EnvironmentObject var bk: BanksiaHandler
    
    var body: some View {
        
        VStack {
            if bk.currentConversations.count > 1 {
                Text("Multiple conversations selected")
            } else if bk.currentConversations.isEmpty {
                
                VStack(alignment: .center) {
                    Text("🕳️")
                        .font(.system(size: 48))
                        .padding(.bottom,6)
                    Text("Nothing selected")
                        .font(.largeTitle)
                        .opacity(0.8)
                        .padding(.bottom,4)
                    Text("Select a conversation on the left to get started.")
                        .opacity(0.4)
                        .padding(.bottom,40)
                }
            } else if let conversation = bk.currentConversations.first {
                Text(conversation.name)
            }
        }
        
    }
}

//#Preview {
//    ModelContainerPreview(ModelContainer.sample) {
//        NavigationContentView()
//            .environmentObject(BanksiaHandler())
//    }
//}
