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

struct DebugInfo: Identifiable {
    var id = UUID()
    var title: String
    var state: String
    var definedOn: String
}

enum SortingOption {
    case title
    case state
    case definedOn
}

struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var sidebar: SidebarHandler
    
    let minWidth: Double = 260
    let minHeight: Double = 190
    
    let frameSizePlay: Double = 200
    //
    //    @State private var debugInfo: [DebugInfo] = [
    //        .init(title: "Editor focused", state: "")
    //    ]
    
    
    
    @State private var sorting: SortingOption = .title
    
    @State private var isHoveringDebug: Bool = false
    
    var body: some View {
        
        
        let debugInfo: [DebugInfo] = [
            DebugInfo(
                title: "Editor focused",
                state: "\(conv.isEditorFocused)",
                definedOn: "\(ConversationHandler.self)"
            ),
            DebugInfo(
                title: "Sidebar visible",
                state: "\(sidebar.isSidebarVisible)",
                definedOn: "\(sidebar)"
            ),
            DebugInfo(
                title: "Sidebar user-dismissed",
                state: "\(sidebar.isSidebarDismissed)",
                definedOn: "\(SidebarHandler.self)"
            )
        ]
        
        let columns: [GridItem] = [
            GridItem(.adaptive(minimum: 100, maximum: 300), alignment: .topLeading)
        ]
        
        var sortedDebugInfo: [DebugInfo] {
            switch sorting {
            case .title:
                return debugInfo.sorted { $0.title < $1.title }
            case .state:
                return debugInfo.sorted { $0.state < $1.state }
            case .definedOn:
                return debugInfo.sorted { $0.definedOn < $1.definedOn }
            }
        }
        
        
        VStack(alignment: .leading) {
            //            Picker("Sort by", selection: $sorting) {
            //                Text("Title").tag(SortingOption.title)
            //                Text("State").tag(SortingOption.state)
            //                Text("Defined on").tag(SortingOption.definedOn)
            //            }
            //            .pickerStyle(SegmentedPickerStyle())
            //            .padding()
            
            LazyVGrid(columns: columns) {
                
                
                
                TableColumn(header: "Title", rows: sortedDebugInfo.map { $0.title })
                TableColumn(header: "State", rows: sortedDebugInfo.map { $0.state })
                TableColumn(header: "Defined on", rows: sortedDebugInfo.map { $0.definedOn })
                
                
                //                VStack(alignment: .leading) {
                //                    TableHeader("Title")
                //                    ForEach(sortedDebugInfo) { info in
                //                        TableRow(info.title)
                //                    }
                //                }
                //                VStack(alignment: .leading) {
                //                    TableHeader("State")
                //                    ForEach(sortedDebugInfo) { info in
                //                        TableRow(info.state)
                //                    }
                //                }
                //                VStack(alignment: .leading) {
                //                    TableHeader("Defined on")
                //                    ForEach(sortedDebugInfo) { info in
                //                        TableRow(info.definedOn)
                //                    }
                //                }
                
                
            } // END pazy grid
            .padding(18)
        }
        .lineSpacing(6.0)
        .caption()
        .frame(
            minWidth: minWidth,
            maxWidth: minWidth + frameSizePlay,
            minHeight: minHeight,
            maxHeight: minHeight + frameSizePlay
        )
        .grainient(seed: 30753, dimming: $pref.uiDimming)
        
    }
}

extension DebugView {
    @ViewBuilder
    func TableHeader(_ label: String) -> some View {
        Text(label)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    func TableRow(_ content: String) -> some View {
        Text(content)
            .frame(height: 20)
    }
    
    //    @ViewBuilder
    //    func TableColumn(_ content: String) -> some View {
    //        Text(content)
    //            .frame(height: 20)
    //    }
    
    @ViewBuilder
    func TableColumn(header: String, rows: [String]) -> some View {
        VStack(alignment: .leading) {
            TableHeader(header)
            ForEach(rows, id: \.self) { row in
                TableRow(row)
            }
        }
    }
}

#Preview {
    DebugView()
        .environment(BanksiaHandler())
        .environment(ConversationHandler())
        .environmentObject(Preferences())
        .environmentObject(SidebarHandler())
    
}
