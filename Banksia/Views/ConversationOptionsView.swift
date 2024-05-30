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
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var pref: Preferences
    
    @FocusState private var isFocused

    @Bindable var conversation: Conversation
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
            CustomSection(label: "Conversation", icon: Icons.messageAlt.icon) {
                
                
                    

                GrainientPicker(seed: $conversation.grainientSeed.boundInt, popup: popup)
                
                Button(role: .destructive) {
                    modelContext.delete(conversation)
                    try? modelContext.save()
                } label: {
                    Label("Delete", systemImage: Icons.trash.icon)
                }
            }
            
            
            
            CustomSection(label: "Debug", icon: Icons.debug.icon) {
                

                
                CustomSection(label: "Debug pane", icon: "window.horizontal.closed", level: .child) {
                    
                    Button {
                        pref.isDebugShowing.toggle()
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
        .frame(
            //            minWidth: 380,
            //            idealWidth: 180,
            maxWidth: 220
            //            minHeight: 280,
            //            idealHeight: 600,
            //            maxHeight: .infinity
        )
        .padding(Styles.paddingGenerous)
        .background(.regularMaterial)
        .grainOverlay()
        .ignoresSafeArea()
//        .grainient(seed: pref.defaultGrainientSeed, dimming: $pref.uiDimming)
        .onAppear {
            isFocused = true
        }
        
    }
}

#if DEBUG


#Preview() {
    ToolbarExpandedView(conversation: Conversation.childcare)
        .environment(ConversationHandler())
        .environment(BanksiaHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(Preferences())
        .environmentObject(PopupHandler())
        .environmentObject(SidebarHandler())
}

#endif

