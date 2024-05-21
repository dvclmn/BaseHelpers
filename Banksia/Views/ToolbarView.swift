//
//  ToolbarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import Navigation
import Popup
import Sidebar
import Modifiers

struct ToolbarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler<Page>
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Query private var conversations: [Conversation]
    
    @State private var title: String = "Here is a short title."
    @State private var message: String? = "And a short message with further info."
    @State private var isLoading: Bool = false
    
    @State private var isToolbarMenuPresented: Bool = false
    
    @State private var isRenaming: Bool = false
    @State private var localLabel: String = ""
    
    @FocusState private var isRenameFieldFocused: Bool
    
    var body: some View {
        
        var currentConversationName: String {
            return conv.getCurrentConversation(within: conversations)?.name ?? ""
        }
        
        HStack(spacing: 14) {
  
            Text(nav.navigationTitle ?? "Banksia")
                .font(.title2)
                .foregroundStyle(.secondary)
                .renamable(itemName: currentConversationName) { newName in
                    conv.getCurrentConversation(within: conversations)?.name = newName
                }
            
//            if isRenaming {
//                TextField("Rename conversation", text: $localLabel)
//                    .textFieldStyle(.customField(text: $localLabel))
//                    .focused($isRenameFieldFocused)
//                    .onSubmit {
//                        rename()
//                    }
//                    .onAppear {
//                        isRenameFieldFocused = true
//                        /// As soon as the TextView comes on-screen, we grab a copy of the label to store in this local scope, to work with
//                        localLabel = conv.getCurrentConversation(within: conversations)?.name ?? ""
//                    }
//    #if os(macOS)
//                    .onExitCommand {
//                        isRenameFieldFocused = false
//                        isRenaming = false
//                        localLabel = ""
//                    }
//    #endif
//            } else {
//                
//                    .gesture(TapGesture(count: 2).onEnded {
//                        isRenameFieldFocused = true
//                        isRenaming = true
//                    })
//            }
//            

            
            Spacer()
            
            // MARK: - 􀅼 New conversation
            Button {
                let newConversation = Conversation(name: "New conversation")
                modelContext.insert(newConversation)
                nav.path.append(Page.conversation(newConversation))
                popup.showPopup(title: "Added new conversation")
            } label: {
                Label("New conversation", systemImage: Icons.plus.icon)
            }
            .buttonStyle(.customButton(labelDisplay: .iconOnly))
            
            
            // MARK: - Conversation prompt
            
            
            
            
            // MARK: - 􀍠 Options
            Button {
                isToolbarMenuPresented.toggle()
            } label: {
                Label("More options", systemImage: Icons.ellipsis.icon)
            }
            .buttonStyle(.customButton(labelDisplay: .iconOnly))
            
            .popover(isPresented: $isToolbarMenuPresented) {
                Button {
                    popup.showPopup(title: "Here's a **popup title**", message: "And a *short* message with further info.")
                } label: {
                    Label("Test popup", systemImage: Icons.text.icon)
                }
            }
            
            
        } // END toolbar hstack
                .safeAreaPadding(.leading, sidebar.isSidebarShowing ? sidebar.sidebarWidth : Styles.paddingToolbarTrafficLightsWidth)
        .frame(
            maxWidth: .infinity,
            minHeight: Styles.toolbarHeight,
            maxHeight: Styles.toolbarHeight,
            alignment: .leading
        )
        /// Allows space for the sidebar toggle button 􀨱 when the sidebar is hidden
        .padding(.leading, sidebar.isSidebarShowing ? 0 : 30)
        
        .padding(.horizontal, 16)
        .background {
            Rectangle().fill(.ultraThinMaterial)
                .safeAreaPadding(.leading, sidebar.isSidebarShowing ? sidebar.sidebarWidth : 0)
        }
        .overlay(alignment: .top) {
            
            PopupView(
                topOffset: 70,
                popup: popup
            )
                    .safeAreaPadding(.leading, sidebar.sidebarWidth)
            
        }
        
        .overlay(alignment: .leading) {
            if sidebar.isRoomForSidebar {
                Button {
                    withAnimation(Styles.animationEased) {
                        sidebar.isSidebarShowing.toggle()
                    }
                } label: {
                    Label("Toggle sidebar", systemImage: Icons.sidebarAlt.icon)
                }
                .buttonStyle(.customButton(hasBackground: !sidebar.isSidebarShowing, labelDisplay: .iconOnly))
                .safeAreaPadding(.leading, Styles.paddingToolbarTrafficLightsWidth)
//                .padding(.trailing, sidebar.isSidebarShowing && sidebar.isRoomForSidebar ? 56 : 0)
            }
        }
    
//            HandyButton(label: "Add sample data", icon: "sparkles") {
//                Conversation.insertSampleData(modelContext: modelContext)
//                try? modelContext.save()
//            }
        
        
//        ToolbarItem() {
//            switch bk.conversationState {
//            case .single:
//                if let conversation = bk.selectedConversation.first {
//                    HandyButton(label: "Delete \(conversation.name)", icon: "trash") {
//                        bk.deleteConversations([conversation], modelContext: modelContext)
//                    }
//                }
//            case .multiple:
//                HandyButton(label: "Delete all conversations", icon: "trash.fill") {
//                    bk.deleteConversations(bk.selectedConversation, modelContext: modelContext)
//                }
//            default:
//                EmptyView()
//            }
            
//        } // END delete
    }
    private func rename() {
        isRenaming = false
        if let currentConversation = conv.getCurrentConversation(within: conversations) {
            currentConversation.name = localLabel
            popup.showPopup(title: "Renamed to \"\(currentConversation.name)\"")
        } else {
                print("No conversation selected")
        }
    }
}


#Preview {
    ContentView()
        .environment(BanksiaHandler())
}
