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

public protocol Debuggable {
    
}

struct DebugRow: Identifiable {
    let id = UUID()
    let title: String
    let state: String
    let definedOn: String
}

struct DebugInfo<Object, Value>: Identifiable {
    var id = UUID()
    var title: String
    var state: [String]
    var definedOn: String
    
    init(
        title: String,
        object: Object,
        keyPath: KeyPath<Object, Value>
    ) {
        self.title = title
        self.state = [String(describing: object[keyPath: keyPath])]
        self.definedOn = String(describing: type(of: object))
    }
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
        
        var debugInfo: [DebugInfo<Any, Any>] {
            [
                DebugInfo(
                    title: "Action log",
                    object: conv,
                    keyPath: \.currentRequest
                ),
                DebugInfo(
                    title: "Sidebar visible",
                    object: sidebar,
                    keyPath: \.isSidebarVisible
                ),
                DebugInfo(
                    title: "Editor height",
                    object: bk,
                    keyPath: \.editorHeight
                )
            ]
        }
        
        
//        let debugInfo: [DebugInfo<Any, Any>] = [
//            DebugInfo(
//                title: "Editor focused",
//                object: conv,
//                keyPath: \.
//            )
            //            DebugInfo(
            //                title: "Sidebar visible",
            //                state: "\(sidebar.isSidebarVisible)",
            //                definedOn: .sidebar
            //            ),
            //            DebugInfo(
            //                title: "Sidebar dismissed",
            //                state: "\(sidebar.isSidebarDismissed)",
            //                definedOn: .sidebar
            //            ),
            //            DebugInfo(
            //                title: "Editor height",
            //                state: "\(bk.editorHeight)",
            //                definedOn: .bk
            //            ),
            //            DebugInfo(
            //                title: "Current request",
            //                state: "\(conv.currentRequest)",
            //                definedOn: .conv
            //            ),
            //            DebugInfo(
            //                title: "Visible message",
            //                state: "\(conv.scrolledMessagePreview ?? "None")",
            //                definedOn: .conv
            //            ),
            //            DebugInfo(
            //                title: "Current Focus",
            //                state: "\(conv.currentRequest.focus.name)",
            //                definedOn: .conv
            //            )
//        ]
        
        let spacing: Double = 0
        
        let columns: [GridItem] = [
            GridItem(.flexible(minimum: 80),                spacing: spacing, alignment: .topLeading),
            GridItem(.flexible(minimum: 40),   spacing: spacing, alignment: .topLeading),
            GridItem(.flexible(minimum: 110),               spacing: spacing, alignment: .topLeading)
        ]
        
        
        var sortedDebugInfo: [DebugRow] {
            let rows = debugInfo.map { DebugRow(title: $0.title, state: $0.state.joined(separator: ", "), definedOn: $0.definedOn) }
            switch sorting {
            case .title:
                return rows.sorted { $0.title < $1.title }
            case .state:
                return rows.sorted { $0.state < $1.state }
            case .definedOn:
                return rows.sorted { $0.definedOn < $1.definedOn }
            }
        }
        
        
        VStack(alignment: .leading, spacing: 20) {
            
            //            Label("Debug", systemImage: Icons.debug.icon)
            Text("Debug")
                .font(.system(size: 22))
                .foregroundStyle(.secondary)
                .padding(4)
            
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
                        rows: sortedDebugInfo.map { $0.definedOn },
                        columnPosition: .end
                    )
                
                
                
            } // END pazy grid
            
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
        //        .toolbar {
        //            ToolbarItem {
        //                Spacer()
        //            }
        //        }
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
            ForEach(rows.indices, id: \.self) { index in
                    CustomTableRow(rows[index], column: column)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(index % 2 == 0 ? Color.black.opacity(0.1) : Color.clear)
                        .clipShape(corners)
                }
        } // END vstack
        .fontWeight(.medium)
        
    } // END CustomTableColumn
    
    
    
    @ViewBuilder
    func CustomTableHeader(_ label: String) -> some View {
        Text(label)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    func CustomTableRow(_ content: [String], column: DebugColumn) -> some View {
        
        ForEach(content, id: \.self) { item in
            var booleanStyle: Color {
                if item == "true" {
                    Swatch.eggplant.colour
                } else if item == "false" {
                    Swatch.peach.colour.opacity(0.8)
                } else {
                    .secondary
                }
            }
            
            Text(item)
                .monospaced()
                .foregroundStyle(booleanStyle)
                .padding(.horizontal, 3)
                .padding(.vertical, 1)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: Styles.roundingTiny))
        }
    }
}

#Preview {
    DebugView()
        .padding(.top,1)
        .environmentObject(BanksiaHandler())
        .environmentObject(ConversationHandler())
        .environmentObject(NavigationHandler())
        .environmentObject(SidebarHandler())
    
}
