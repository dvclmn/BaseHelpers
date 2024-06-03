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
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    
    @State private var isLoading: Bool = false
    
    @State private var isRenaming: Bool = false
    
    @FocusState private var isSearchFocused: Bool
    
    @Binding var conversationName: String
    @Binding var conversationGrainientSeed: Int
    
    var body: some View {
        
        @Bindable var conv = conv
        
        VStack(spacing:0) {
            
            if pref.isToolbarShowing {
                
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
                
                .frame(
                    maxWidth: .infinity,
                    minHeight: Styles.toolbarHeight,
                    maxHeight: Styles.toolbarHeight,
                    alignment: .leading
                )
                .safeAreaPadding(.leading, !sidebar.isSidebarVisible ? Styles.toolbarSpacing : (sidebar.isSidebarVisible ? sidebar.sidebarWidth : Styles.paddingToolbarTrafficLightsWidth))

                /// Allows space for the sidebar toggle button 􀨱 when the sidebar is hidden
                .padding(.leading, sidebar.isSidebarVisible ? 0 : 110)
                
                .padding(.horizontal, Styles.toolbarSpacing)
                .background {
                    Rectangle().fill(.ultraThinMaterial)
                        .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
                }
                
                ToolbarExpandedView(conversationGrainientSeed: $conversationGrainientSeed)
                
            } // END toolbar toggle
            
        } // END vstack
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
        
        // MARK: - 􀨱 Sidebar buttons
        .overlay(alignment: .topLeading) {
            
            HStack(spacing: 0) {

                if pref.isToolbarShowing {
                    Button {
                        sidebar.toggleSidebar()
                    } label: {
                        Label("Toggle sidebar", systemImage: Icons.sidebarAlt.icon)
                    }
                }
                
                // MARK: - 􀅼 New conversation
                if sidebar.isSidebarVisible {
                    NewConversationButton()
                        .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
                    
                    
                } // END sidebar showing check
                
                
            } // END hstack
            
            .task(id: conv.currentRequest) {
                switch conv.currentRequest {
                case .search:
                    
                    conv.currentRequest = .none
                default:
                    break
                }
            }
            
            .frame(
                height: Styles.toolbarHeight
            )
            .safeAreaPadding(.leading, Styles.paddingToolbarTrafficLightsWidth)
            
            .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
        } // END toolbar sidebar controls overlay
        
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
        
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

#if DEBUG


#Preview() {
    ToolbarView(
        conversationName: .constant("Butts"),
        conversationGrainientSeed: .constant(GrainientPreset.sunset.seed)
    )
        .environment(ConversationHandler())
        .environment(BanksiaHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(Preferences())
        .environmentObject(PopupHandler())
        .environmentObject(SidebarHandler())
        .background(.black)
            .frame(width: 500, height: 700)
}

#endif

