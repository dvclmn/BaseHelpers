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

struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var nav: NavigationHandler
    
    @State private var rowHeights: [Int: CGFloat] = [:]
    
    let minWidth: Double = 260
    let minHeight: Double = 190
    
    let rowPaddingHorizontal: Double = 8
    let rowPaddingVertical: Double = 4
    
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
                state: DebugState(main: "\(conv.currentRequest)"),
//                state: DebugState(main: "\(conv.currentRequest)", log: [
//                    "\(conv.currentRequest)",
//                    "\(conv.currentRequest)",
//                    "\(conv.currentRequest)",
//                    "\(conv.currentRequest)",
//                    "\(conv.currentRequest)"
//                ]),
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
                        .lineLimit(1)
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
            alignment: .leading
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
        
        var columnMinWidth: Double {
            switch column {
            case .title:
                return 100
            case .state:
                return 60
            case .definedOn:
                return 100
            }
        }
        var columnMaxWidth: Double {
            switch column {
            case .title:
                return .infinity
            case .state:
                return 80
            case .definedOn:
                return .infinity
            }
        }
        
        
        VStack(alignment: .leading, spacing: 0) {
            
            CustomTableHeader(column.rawValue)
                .frame(maxWidth: columnMaxWidth, alignment: .leading)
            
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                
                Group {
                    switch column {
                    case .title:
                        CustomTableRow(content: row.title, rowIndex: index, column: column)
                    case .state:
                        CustomTableRow(content: row.state.main, subItems: row.state.log, rowIndex: index, column: column)
                    case .definedOn:
                        CustomTableRow(content: row.definedOn.rawValue, rowIndex: index, column: column)
                    }
                }
                .frame(
                    minWidth: columnMinWidth,
                    maxWidth: columnMaxWidth,
                    minHeight: rowHeights.wrappedValue[index] ?? .zero,
                    alignment: .topLeading
                )
                .padding(.horizontal, rowPaddingHorizontal)
                .padding(.vertical, rowPaddingVertical)
                .background(index % 2 == 0 ? Color.black.opacity(0.1) : Color.clear)
                .clipShape(corners)
            } // END foreach
        } // END vstack
    } // END table column
    
    @ViewBuilder
    func CustomTableHeader(_ label: String) -> some View {
        Text(label)
            .textCase(.uppercase)
            .foregroundStyle(.tertiary)
            .fontWeight(.semibold)
            .padding(.horizontal, rowPaddingHorizontal)
            .padding(.vertical, rowPaddingVertical + 4)
    }
    
    @ViewBuilder
    func CustomTableRow(
        content: String,
        subItems: [String] = [],
        rowIndex: Int,
        column: DebugColumn
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
            
            Group {
                switch column {
                case .title:
                    Text(content)
                        .foregroundStyle(.primary)
                    
                case .state:
                    Text(content)
                        .foregroundStyle(booleanStyle)
                        .monospaced()
                        .padding(.horizontal, 3)
                        .padding(.vertical, 1)
                        .background(.black.opacity(0.2))
                        .clipShape(.rect(cornerRadius: Styles.roundingTiny))
                    
                    
                case .definedOn:
                    Text(content)
                        .foregroundStyle(.secondary)
                }
                ForEach(subItems, id: \.self) { item in
                    Text(item)
                }
            }
            .fontWeight(.medium)
            
            
            
            
            
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
        .environment(ConversationHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(SidebarHandler())
        .frame(width: 400, height: 600)
}
