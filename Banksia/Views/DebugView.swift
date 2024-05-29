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

struct DebugInfo: Identifiable {
    var id = UUID()
    var title: String
    var state: String
    var definedOn: DefinedOn
}


enum DebugColumn {
    case title
    case state
    case definedOn
    
    var title: String {
        switch self {
        case .title:
            "Title"
        case .state:
            "State"
        case .definedOn:
            "Defined on"
        }
    }
}

enum DefinedOn {
    case conv
    case sidebar
    
    var name: String {
        switch self {
        case .conv:
            "ConversationHandler"
        case .sidebar:
            "SidebarHandler"
        }
    }
}

enum ColumnPosition {
    case beginning
    case middle
    case end
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
    
    
    
    @State private var sorting: DebugColumn = .title
    
    @State private var isHoveringDebug: Bool = false
    
    var body: some View {
        
        
        let debugInfo: [DebugInfo] = [
            DebugInfo(
                title: "Editor focused",
                state: "\(conv.isEditorFocused)",
                definedOn: .conv
            ),
            DebugInfo(
                title: "Sidebar visible",
                state: "\(sidebar.isSidebarVisible)",
                definedOn: .sidebar
            ),
            DebugInfo(
                title: "Sidebar dismissed",
                state: "\(sidebar.isSidebarDismissed)",
                definedOn: .sidebar
            )
        ]
        
//        let columns: [GridItem] = [
//            GridItem(.adaptive(minimum: 40), alignment: .topLeading)
//        ]
        
        let spacing: Double = 0
        
        let columns: [GridItem] = [
            GridItem(.flexible(minimum: 40),                spacing: spacing, alignment: .topLeading),
            GridItem(.flexible(minimum: 40, maximum: 80),   spacing: spacing, alignment: .topLeading),
            GridItem(.flexible(minimum: 120),                spacing: spacing, alignment: .topLeading)
        ]
        
//        let columns: [GridItem] = [
//            GridItem(.fixed(120), alignment: .topLeading),
//            GridItem(.fixed(120), alignment: .topLeading),
//            GridItem(.fixed(120), alignment: .topLeading)
//        ]
        
        var sortedDebugInfo: [DebugInfo] {
            switch sorting {
            case .title:
                return debugInfo.sorted { $0.title < $1.title }
            case .state:
                return debugInfo.sorted { $0.state < $1.state }
            case .definedOn:
                return debugInfo.sorted { $0.definedOn.name < $1.definedOn.name }
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
                
                
                
                CustomTableColumn(
                    column: DebugColumn.title,
                    rows: sortedDebugInfo.map { $0.title },
                    columnPosition: .beginning
                )
                CustomTableColumn(
                    column: DebugColumn.state,
                    rows: sortedDebugInfo.map { $0.state }
                )
                CustomTableColumn(
                    column: DebugColumn.definedOn,
                    rows: sortedDebugInfo.map { $0.definedOn.name },
                    columnPosition: .end
                )
                
                
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
    func CustomTableHeader(_ label: String) -> some View {
        Text(label)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    func CustomTableRow(_ content: String, column: DebugColumn) -> some View {
        
        var booleanStyle: Color {
            if content == "true" {
                Swatch.eggplant.colour
            } else if content == "false" {
                Swatch.peach.colour.opacity(0.8)
            } else {
                .secondary
            }
        }
        
        Group {
            switch column {
            case .title:
                Text(content)
            case .state:
                Text(content)
                    .monospaced()
                    .foregroundStyle(booleanStyle)
                    .padding(.horizontal, 3)
                    .padding(.vertical, 1)
                    .background(.black.opacity(0.3))
                    .clipShape(.rect(cornerRadius: Styles.roundingTiny))
            case .definedOn:
                Text(content)
                    .foregroundStyle(.secondary)
            }
        }
            .frame(height: 20)
    }
    
    @ViewBuilder
    func CustomTableColumn(
        column: DebugColumn,
        rows: [String],
        columnPosition: ColumnPosition = .middle
    ) -> some View {
        
        let rounding: Double = Styles.roundingSmall
        
        var corners: UnevenRoundedRectangle {
            switch columnPosition {
            case .beginning:
                return .rect(
                    topLeadingRadius: rounding,
                    bottomLeadingRadius: rounding,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            case .middle:
                return .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            case .end:
                return .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: rounding,
                    topTrailingRadius: rounding
                )
            }
        }
        
        
        VStack(alignment: .leading, spacing: 0) {
            CustomTableHeader(column.title)
                .padding(.horizontal, 6)
                .padding(.bottom, 6)
            ForEach(Array(zip(rows.indices, rows)), id: \.0) { index, row in
                CustomTableRow(row, column: column)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(index % 2 == 0 ? Color.black.opacity(0.1) : Color.clear)
                    .clipShape(corners)
                    
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
