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
    
    @State private var rowHeights: [Int: CGFloat] = [:]
    
    @SceneStorage("isColumnOneShowingKey") var isColumnOneShowing: Bool = true
    @SceneStorage("isColumnTwoShowingKey") var isColumnTwoShowing: Bool = true
    @SceneStorage("isColumnthreeShowingKey") var isColumnThreeShowing: Bool = true
    
    
    
    let faded: Double = 0.3
    
    @State private var sorting: DebugColumn = .label
    
    @State private var isHoveringDebug: Bool = false
    
    var body: some View {
        
        let columns: [DebugColumn] = DebugColumn.allCases
            let rows: [Row<DebugColumn>] = [
                Row(cells: [
                    Cell(column: .label, value: "Row 1 Title"),
                    Cell(column: .state, value: "Active"),
                    Cell(column: .definedOn, value: "2023-10-01")
                ]),
                Row(cells: [
                    Cell(column: .label, value: "Row 2 Title"),
                    Cell(column: .state, value: "Inactive"),
                    Cell(column: .definedOn, value: "2023-10-02")
                ])
            ]
        
        
//        var visibleColumns: [DebugColumn] {
//            var columns: [DebugColumn] = []
//            
//            if isColumnOneShowing {
//                columns.append(.label)
//            }
//            if isColumnTwoShowing {
//                columns.append(.state)
//            }
//            if isColumnThreeShowing {
//                columns.append(.definedOn)
//            }
//            
//            return columns
//        }
//        
        CustomTable(title: "Debug", columns: columns, rows: rows)
        
        .grainient(
            seed: GrainientPreset.algae.seed,
            version: .v1,
            dimming: $pref.uiDimming
        )
        .ignoresSafeArea()
        .background(Swatch.slate.colour)
    }
}

extension DebugView {
    
    
    
    
    
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
