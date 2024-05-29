//
//  DebugView.swift
//  Banksia
//
//  Created by Dave Coleman on 29/5/2024.
//

import SwiftUI
import GeneralStyles
import Grainient
import Sidebar

struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var sidebar: SidebarHandler
    
    let minWidth: Double = 260
    let minHeight: Double = 190
    
    let frameSizePlay: Double = 200
    
    @State private var isHoveringDebug: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            let debugString: String = """
                    Editor focused: \t\t\t\(conv.isEditorFocused)
                    Sidebar visible: \t\t\t\(sidebar.isSidebarVisible)
                    Sidebar user-dismissed: \t\(sidebar.isSidebarDismissed)
                    Editor focused: \(conv.isEditorFocused)
                    Editor focused: \(conv.isEditorFocused)
                    """
            Text(debugString)
        }
        .lineSpacing(6.0)
        .caption()
//        .padding()
        .frame(
                    minWidth: minWidth,
                    maxWidth: minWidth + frameSizePlay,
                    minHeight: minHeight,
                    maxHeight: minHeight + frameSizePlay
                )
        .grainient(seed: GrainientSettings.generateGradientSeed(), dimming: $pref.uiDimming)
        
    }
}

#Preview {
    DebugView()
        .environment(BanksiaHandler())
        .environment(ConversationHandler())
        .environmentObject(Preferences())
        .environmentObject(SidebarHandler())
    
}
