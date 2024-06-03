//
//  DetailView.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import SwiftUI
import Popup
import Sidebar
import SwiftData
import StateView
import GeneralUtilities

struct DetailView: View {
    @Environment(BanksiaHandler.self) private var bk
    
    @Query private var conversations: [Conversation]
    
    var page: Page? = nil
    
    var body: some View {
        
        VStack {
            switch page {
                
                // MARK: - Conversation
            case .conversation(let conversationStatic):
                
                if let conversation = conversations.first(where: {$0.persistentModelID == conversationStatic.persistentModelID}) {
                    
                    @Bindable var conversation = conversation
                    
                    DetailWrapper(
                        conversationName: $conversation.name,
                        conversationGrainientSeed: $conversation.grainientSeed.boundInt
                    ) {
                        ConversationView(conversation: conversation)
                    } // END detail wrapper
                    
                } else {
                    
                    DetailWrapper {
                        StateView(title: "No Conversations")
                    } // END detail wrapper
                }
                
                // MARK: - Feedback
            case .feedback:
                
                DetailWrapper {
                    FeedbackView()
                } // END detail wrapper
                
                
                // MARK: - No Page
            default:
                HStack(spacing: 0) {
                    DetailWrapper {
                        StateView(title: "No Page Selection")
                    } // END detail wrapper
                    
                } // END hstack
                
            } // END switch
        } // END main vstack
        .overlay {
            //            QuickOpenView()
        }
        
    }
}


struct DetailWrapper<Content: View>: View {
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var popup: PopupHandler
    
    @Binding var conversationName: String
    @Binding var conversationGrainientSeed: Int
    
    let content: Content
    
    init(
        conversationName: Binding<String> = .constant(""),
        conversationGrainientSeed: Binding<Int> = .constant(0),
        @ViewBuilder content: () -> Content
    ) {
        self._conversationName = conversationName
        self._conversationGrainientSeed = conversationGrainientSeed
        self.content = content()
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            SidebarView()
            
            VStack {
                content
            }
            .frame(maxWidth: .infinity)
        }
        .overlay(alignment: .top) {
            ToolbarView(
                conversationName: $conversationName,
                conversationGrainientSeed: $conversationGrainientSeed
            )
        }
        .overlay(alignment: .top) {
            PopupView(
                topOffset: 70,
                popup: popup
            )
            .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
        }
        .navigationBarBackButtonHidden(true)
    }
}


