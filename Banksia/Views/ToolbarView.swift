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
import Grainient
import Icons

struct ToolbarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler<Page>
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var pref: Preferences
    
    @State private var isLoading: Bool = false
    
    @State private var isToolbarMenuPresented: Bool = false
    
    @State private var isRenaming: Bool = false
    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        @Bindable var conv = conv
        
        HStack(spacing: 14) {
            
            Text(nav.navigationTitle ?? "Banksia")
                .font(.title2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .renamable(
                    isRenaming: $isRenaming,
                    itemName: conversation.name
                ) { newName in
                    conversation.name = newName
                    popup.showPopup(title: "Renamed to \"\(newName)\"")
                }
            
            Spacer()
            
            if !sidebar.isSidebarVisible {
                NewConversationButton()
            }
            
            // MARK: - 􀈎 Edit conversation
            Button {
                conv.isConversationEditorShowing.toggle()
            } label: {
                Label("Edit conversation prompt", systemImage: Icons.edit.icon)
            }
            
            
            // MARK: - 􁎄 Grainient picker
            GrainientPicker(
                seed: $conversation.grainientSeed,
                popup: popup
            )
            
            // MARK: - 􀍠 Options
            Button {
                isToolbarMenuPresented.toggle()
            } label: {
                Label("More options", systemImage: Icons.ellipsis.icon)
            }
            //            .buttonStyle(.customButton(labelDisplay: .iconOnly))
            
            .popover(isPresented: $isToolbarMenuPresented) {
                Button {
                    popup.showPopup(title: "Here's a **popup title**", message: "And a *short* message with further info.")
                } label: {
                    Label("Test popup", systemImage: Icons.text.icon)
                }
            }
            
        } // END toolbar hstack
        .buttonStyle(
            .customButton(
                hasBackground: false,
                labelDisplay: .iconOnly
            )
        )
        .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : Styles.paddingToolbarTrafficLightsWidth)
        .frame(
            maxWidth: .infinity,
            minHeight: Styles.toolbarHeight,
            maxHeight: Styles.toolbarHeight,
            alignment: .leading
        )
        /// Allows space for the sidebar toggle button 􀨱 when the sidebar is hidden
        .padding(.leading, sidebar.isSidebarVisible ? 0 : 30)
        
        .padding(.horizontal, 16)
        .background {
            Rectangle().fill(.ultraThinMaterial)
                .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
        }
        .overlay(alignment: .top) {
            
            PopupView(
                topOffset: 70,
                popup: popup
            )
            .safeAreaPadding(.leading, sidebar.sidebarWidth)
            
        }
        
        // MARK: - 􀨱 Sidebar buttons
        .overlay(alignment: .leading) {
            
            HStack {
//            if sidebar.isRoomForSidebar {
                    Button {
                            if !sidebar.isRoomForSidebar {
                                sidebar.requestRoomForSidebar()
                            } else {
                                withAnimation(Styles.animationEased) {
                                sidebar.toggleSidebar()
                                }
                            }
                    } label: {
                        Label("Toggle sidebar", systemImage: Icons.sidebarAlt.icon)
                    }
                    
//                }  END room for sidebar check
                
                // MARK: - 􀅼 New conversation
                if sidebar.isSidebarVisible {
                    NewConversationButton()
                        .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
                    
                    
                } // END sidebar showing check
            } // END hstack
            .safeAreaPadding(.leading, Styles.paddingToolbarTrafficLightsWidth)
                .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
        } // END toolbar sidebar controls overlay
        
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
}

extension ToolbarView {
    @ViewBuilder
    func NewConversationButton() -> some View {
        Button {
            conv.isRequestingNewConversation = true
        } label: {
            Label("New conversation", systemImage: Icons.plus.icon)
        }
    }
}
