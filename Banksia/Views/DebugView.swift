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

struct DebugRow: Identifiable {
    var id = UUID()
    var title: String
    var state: DebugState
    var definedOn: DefinedOn
}

struct DebugState {
    var main: String
    var log: [String] = []
}

struct RowHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        for (index, height) in nextValue() {
            value[index] = max(value[index] ?? 0, height)
        }
    }
}

enum DebugColumn: String, CaseIterable {
    case title = "Title"
    case state = "State"
    case definedOn = "Defined on"
    
    var columnPosition: ColumnPosition {
        switch self {
        case .title:
                .beginning
        case .state:
                .middle
        case .definedOn:
                .end
        }
    }
}

enum DefinedOn: String {
    case conv = "ConversationHandler"
    case sidebar = "SidebarHandler"
    case bk = "BanksiaHandler"
    case nav = "NavigationHandler"
}

enum ColumnPosition {
    case beginning
    case middle
    case end
}


struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var conv: ConversationHandler
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var nav: NavigationHandler
    
    @State private var rowHeights: [Int: CGFloat] = [:]
    
    let minWidth: Double = 260
    let minHeight: Double = 190
    
    let frameSizePlay: Double = 200
    
    @State private var sorting: DebugColumn = .title
    
    @State private var isHoveringDebug: Bool = false
    
    var body: some View {
        
        let debugRows: [DebugRow] = [
            DebugRow(
                title: "Editor focused",
                state: DebugState(main:"\(conv.isEditorFocused)"),
                definedOn: .conv
            ),
            DebugRow(
                title: "Sidebar visible",
                state: DebugState(main:"\(sidebar.isSidebarVisible)"),
                definedOn: .sidebar
            ),
            DebugRow(
                title: "Sidebar dismissed",
                state: DebugState(main:"\(sidebar.isSidebarDismissed)"),
                definedOn: .sidebar
            ),
            DebugRow(
                title: "Editor height",
                state: DebugState(main:"\(bk.editorHeight)"),
                definedOn: .bk
            ),
            DebugRow(
                title: "Current request",
                state: DebugState(main: "\(conv.currentRequest)", log: [
                    "\(conv.currentRequest)",
                    "\(conv.currentRequest)",
                    "\(conv.currentRequest)",
                    "\(conv.currentRequest)",
                    "\(conv.currentRequest)"
                ]),
                definedOn: .conv
            ),
            DebugRow(
                title: "Visible message",
                state: DebugState(main:"\(conv.scrolledMessagePreview ?? "None")"),
                definedOn: .conv
            ),
            DebugRow(
                title: "Current Focus",
                state: DebugState(main:"\(conv.currentRequest.focus.name)"),
                definedOn: .conv
            )
        ]
        
        //        var sortedDebugRow: [DebugRow] {
        //            switch sorting {
        //            case .title:
        //                return debugInfo.sorted { $0.title < $1.title }
        //            case .state:
        //                return debugInfo.sorted { $0.state < $1.state }
        //            case .definedOn:
        //                return debugInfo.sorted { $0.definedOn.name < $1.definedOn.name }
        //            }
        //        }
        
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Debug")
                .font(.system(size: 22))
                .foregroundStyle(.secondary)
                .padding(4)
            
            
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(DebugColumn.allCases, id: \.self) { column in
                        CustomTableColumn(
                            column: column,
                            rows: debugRows,
                            rowHeights: $rowHeights,
                            columnPosition: column.columnPosition
                        )
                    }
                }
            }
            .onPreferenceChange(RowHeightPreferenceKey.self) { value in
                        rowHeights = value
                    }
            
            Spacer()
        }
        .padding(18)
        .safeAreaPadding(.top, isPreview ? 0 : 30)
        .font(.system(size: 12))
        
        .frame(
            minWidth: minWidth,
            idealWidth: .infinity,
            maxWidth: .infinity,
            minHeight: minHeight,
            maxHeight: .infinity,
            alignment: .trailing
        )
        
        .grainient(
            seed: GrainientPreset.algae.seed,
            version: .v1,
            dimming: $bk.uiDimming
        )
        .ignoresSafeArea()
        .background(Swatch.slate.colour)
    }
}

extension DebugView {
    
    
    
    
    @ViewBuilder
    func CustomTableColumn(
        column: DebugColumn,
        rows: [DebugRow],
        rowHeights: Binding<[Int : CGFloat]>,
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
            CustomTableHeader(column.rawValue)
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                
                
                Group {
                    switch column {
                    case .title:
                        CustomTableRow(content: row.title, rowIndex: index)
                    case .state:
                        CustomTableRow(content: row.state.main, subItems: row.state.log, rowIndex: index)
                    case .definedOn:
                        CustomTableRow(content: row.definedOn.rawValue, rowIndex: index)
                    }
                }
                
                .frame(height: rowHeights.wrappedValue[index] ?? .zero)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(index % 2 == 0 ? Color.black.opacity(0.1) : Color.clear)
                .clipShape(corners)
            } // END foreach
        } // END vstack
    } // END table column
    
    @ViewBuilder
    func CustomTableHeader(_ label: String) -> some View {
        Text(label)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    func CustomTableRow(
        content: String,
        subItems: [String] = [],
        rowIndex: Int
    ) -> some View {
        
        var booleanStyle: Color {
            if content == "true" {
                Swatch.eggplant.colour
            } else if content == "false" {
                Swatch.peach.colour.opacity(0.8)
            } else {
                .secondary
            }
        }
        
        VStack(alignment: .leading) {
            
            Text(content)
                .monospaced()
                .foregroundStyle(booleanStyle)
                .padding(.horizontal, 3)
                .padding(.vertical, 1)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: Styles.roundingTiny))
            
            ForEach(subItems, id: \.self) { item in
                Text(item)
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear.preference(key: RowHeightPreferenceKey.self, value: [rowIndex: geometry.size.height])
            }
        )
    }
    
}

#Preview {
    DebugView()
        .padding(.top,1)
        .environmentObject(BanksiaHandler())
        .environmentObject(ConversationHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(SidebarHandler())
        .frame(width: 500, height: 600)
}
