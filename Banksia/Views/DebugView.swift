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
import Swatches
import Icons
import GeneralUtilities
import Table



struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var nav: NavigationHandler
        
    
    @State private var sorting: DebugColumn = .label
    
    @State private var isHoveringDebug: Bool = false
    
    var body: some View {
        
        
        let columns: [DebugColumn] = DebugColumn.allCases
        
        let rows: [CustomRow<DebugColumn>] = [
            CustomRow(cells: [
                .label: "Sidebar visible",
                .state: "\(sidebar.isSidebarVisible)",
                .definedOn: DefinedOn.sidebar.rawValue
            ]),
            CustomRow(cells: [
                .label: "Sidebar dismissed",
                .state: "\(sidebar.isSidebarDismissed)",
                .definedOn: DefinedOn.sidebar.rawValue
            ]),
            CustomRow(cells: [
                .label: "Editor height",
                .state: "\(pref.editorHeight)",
                .definedOn: DefinedOn.bk.rawValue
            ]),
            CustomRow(cells: [
                .label: "Current request",
                .state: "\(conv.currentRequest)",
                .definedOn: DefinedOn.conv.rawValue
            ]),
            CustomRow(cells: [
                .label: "Current Focus",
                .state: "\(conv.currentRequest.focus.name)",
                .definedOn: DefinedOn.conv.rawValue
            ])
        ]
        

       
        
        CustomTable(title: "Debug", columns: columns, rows: rows)
            .padding(18)
            .safeAreaPadding(.top, isPreview ? 0 : 30)
                .grainient(
                    seed: GrainientPreset.algae.seed,
                    version: .v1,
                    dimming: $pref.uiDimming
                )
                .ignoresSafeArea()
                .background(Swatch.slate.colour)
    }
}


#Preview {
    DebugView()
        .padding(.top,1)
        .environment(BanksiaHandler())
        .environment(ConversationHandler())
        .environmentObject(Preferences())
        .environmentObject(NavigationHandler())
        .environmentObject(SidebarHandler())
        .frame(width: 400, height: 600)
}
