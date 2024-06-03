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
import Form

struct ToolbarExpandedView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(ConversationHandler.self) private var conv
    
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    
    @FocusState private var isFocused
    
    @Binding var conversationGrainientSeed: Int
    
    var body: some View {
        
        @Bindable var bk = bk
        
        if bk.isToolbarExpanded || isPreview {
            Form {
                CustomSection(label: "Conversation", icon: Icons.messageAlt.icon) {
                    
                    LabeledContent {
                        GrainientPicker(
                            seed: $pref.defaultGrainientSeed,
                            popup: popup,
                            viewSeedEnabled: false
                        )
                    } label: {
                        Label("Default background", systemImage: Icons.gradient.icon)
                        Text("Customise the gradient background that appears when no conversation is selected.")
                            .caption()
                    }
                    
                    GrainientPreviews(seed: $pref.defaultGrainientSeed)
                    
                    
                    
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
                    
                    Toggle(isOn: $pref.isMessageInfoShowing) {
                        Label(pref.isMessageInfoShowing ? "Hide Message info" : "Show Message info", systemImage: Icons.info.icon)
                    }
                    .tint(pref.accentColour.colour)
                    
                    
                    Button {
                        pref.isDebugShowing.toggle()
                    } label: {
                        Label("Toggle debug pane", systemImage: Icons.debug.icon)
                    }
                    
                    
                    Button {
                        popup.showPopup(title: "Here's a **popup title**", message: "And a *short* message with further info.")
                    } label: {
                        Label("Test popup", systemImage: "rectangle.ratio.16.to.9")
                    }
                    
                } // END custom section
                
                Spacer()
                
            } // END Vstack
            .formStyle(.customForm())
            .focusable()
            .focused($isFocused)
            .focusEffectDisabled()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            
            .onExitCommand {
                bk.isToolbarExpanded = false
            }
            .onAppear {
                isFocused = true
            }
            .background {
                Rectangle()
                    .fill(.thickMaterial)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: Styles.roundingMedium)
            )
            .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
            .padding(.top, Styles.paddingGenerous)
            .padding(.horizontal, Styles.paddingGenerous)
            .padding(.bottom, Styles.paddingGenerous + conv.editorHeight)
            
            
        }
    }
}

#if DEBUG


#Preview() {
    ToolbarExpandedView(conversationGrainientSeed: .constant(568309))
        .environment(ConversationHandler())
        .environment(BanksiaHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(Preferences())
        .environmentObject(PopupHandler())
        .environmentObject(SidebarHandler())
        .frame(width: 400, height: 600)
//        .background(.red.opacity(0.8))
}

#endif

