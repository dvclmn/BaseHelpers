//
//  ToolbarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import SwiftData
import GeneralStyles
import Navigation
import Popup
import Sidebar
import Modifiers
import Grainient
import Icons
import TextField
import GeneralUtilities
import Swatches

struct ToolbarView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var conv: ConversationHandler
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var nav: NavigationHandler
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    
    @State private var isLoading: Bool = false
    
    @State private var isRenaming: Bool = false
    
    @FocusState private var isSearchFocused: Bool
    
    @Binding var conversationName: String
    @Binding var conversationGrainientSeed: Int
    
    var body: some View {
        
        VStack(spacing:0) {
            HStack(spacing: 14) {
                
                Text(nav.navigationTitle ?? "Banksia")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .renamable(
                        isRenaming: $isRenaming,
                        itemName: conversationName
                    ) { newName in
                        conversationName = newName
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
                

                
                // MARK: - 􀍠 Expanded
                Button {
                    bk.isToolbarExpanded.toggle()
                    
                } label: {
                    Label("More options", systemImage: Icons.ellipsis.icon)
                }
                
                
                
                // MARK: - Search
                TextField("Search messages", text: $conv.searchText, prompt: Text("Search…"))
                    .textFieldStyle(.customField(text: $conv.searchText, isFocused: isSearchFocused))
                    .focused($isSearchFocused)
                    .frame(maxWidth: isSearchFocused ? 240 : 120)
                    .onExitCommand {
                        isSearchFocused = false
                    }
                
            } // END toolbar hstack
            .buttonStyle(
                .customButton(
                    hasBackground: false,
                    labelDisplay: .iconOnly
                )
            )

            .animation(Styles.animation, value: isSearchFocused)
            .safeAreaPadding(.leading, isPreview && !sidebar.isSidebarVisible ? Styles.toolbarSpacing : (sidebar.isSidebarVisible ? sidebar.sidebarWidth : Styles.paddingToolbarTrafficLightsWidth))
            .frame(
                maxWidth: .infinity,
                minHeight: Styles.toolbarHeight,
                maxHeight: Styles.toolbarHeight,
                alignment: .leading
            )
            /// Allows space for the sidebar toggle button 􀨱 when the sidebar is hidden
            .padding(.leading, sidebar.isSidebarVisible ? 0 : 30)
            
            .padding(.horizontal, Styles.toolbarSpacing)
            .background {
                Rectangle().fill(.ultraThinMaterial)
                    .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
            }
            
            
            ToolbarExpandedView(conversationGrainientSeed: $conversationGrainientSeed)
            
        } // END vstack
        
        
        
        
        
        // MARK: - 􀨱 Sidebar buttons
        .overlay(alignment: .topLeading) {
            
            HStack {
                //            if sidebar.isRoomForSidebar {
                Button {
                    sidebar.toggleSidebar()
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
            .frame(height: Styles.toolbarHeight)
            
            .task(id: conv.currentRequest) {
                switch conv.currentRequest {
                case .search:
                    
                    conv.currentRequest = .none
                default:
                    break
                }
            }
            
            
            .safeAreaPadding(.leading, isPreview ? Styles.toolbarSpacing : Styles.paddingToolbarTrafficLightsWidth)
            .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
        } // END toolbar sidebar controls overlay
//        .onAppear {
//            if isPreview {
//                bk.isToolbarExpanded = true
//            }
//        }
        
    }
}

extension ToolbarView {

    @ViewBuilder
    func NewConversationButton() -> some View {
        Button {
            conv.currentRequest = .new
        } label: {
            Label("New conversation", systemImage: Icons.plus.icon)
        }
    }
}
