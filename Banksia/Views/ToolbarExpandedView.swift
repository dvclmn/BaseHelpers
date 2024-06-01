//
//  ToolbarExpandedView.swift
//  Banksia
//
//  Created by Dave Coleman on 29/5/2024.
//

import SwiftUI
import Popup
import Icons
import Swatches
import GeneralStyles
import Grainient
import GeneralUtilities
import Sidebar
import Button
import GrainientPicker

struct ToolbarExpandedView: View {

    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var conv: ConversationHandler
    
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var nav: NavigationHandler
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    
    @FocusState private var isFocused

    @Binding var conversationGrainientSeed: Int
    
    var body: some View {
        
        if bk.isToolbarExpanded {
        
            VStack(alignment: .leading) {
                CustomSection(label: "Conversation", icon: Icons.messageAlt.icon) {

                    GrainientPicker(seed: $conversationGrainientSeed, popup: popup)
                    
                    Button(role: .destructive) {
//                        modelContext.delete(conversation)
//                        try? modelContext.save()
                        
                        conv.currentRequest = .delete
                        
                    } label: {
                        Label("Delete", systemImage: Icons.trash.icon)
                    }
                }
                
                
                
                CustomSection(label: "Debug", icon: Icons.debug.icon) {
                    

                    
                    CustomSection(label: "Debug pane", icon: "window.horizontal.closed", level: .child) {
                        
                        Button {
                            bk.isDebugShowing.toggle()
                        } label: {
                            Label("Toggle debug pane", systemImage: Icons.debug.icon)
                        }

                    }
                    

                    Button {
                        popup.showPopup(title: "Here's a **popup title**", message: "And a *short* message with further info.")
                    } label: {
                        Label("Test popup", systemImage: "rectangle.ratio.16.to.9")
                    }
                    
                } // END custom section
                
                
                
            } // END Vstack
            .focusable()
            .focused($isFocused)
            .focusEffectDisabled()
//            .frame(maxWidth: .infinity)
            .padding(Styles.paddingGenerous)
//            .padding(.top, Styles.toolbarHeight)
            .safeAreaPadding(.leading, isPreview && !sidebar.isSidebarVisible ? Styles.toolbarSpacing : (sidebar.isSidebarVisible ? sidebar.sidebarWidth : Styles.paddingToolbarTrafficLightsWidth))
            .padding(.leading, sidebar.isSidebarVisible ? 0 : 30)
            .background {
                Rectangle().fill(.thickMaterial)
                    .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
            }
            .onExitCommand {
                bk.isToolbarExpanded = false
            }
            .onAppear {
                isFocused = true
            }
        }
    }
}

//#if DEBUG
//
//
//#Preview() {
//    ToolbarExpandedView(conversationGrainientSeed: .constant(568309))
//        .environment(ConversationHandler())
//        .environmentObject(BanksiaHandler())
//        .environmentObject(NavigationHandler())
//        
//        .environmentObject(PopupHandler())
//        .environmentObject(SidebarHandler())
//}
//
//#endif

