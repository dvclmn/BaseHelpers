//
//  File.swift
//
//
//  Created by Dave Coleman on 25/7/2024.
//

import SwiftUI


struct CaptureItemFrame: ViewModifier {
    let id: AnyHashable
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: ItemFramePreferenceKey.self,
                    value: [id: geometry.frame(in: .named("listContainer"))]
                )
            })
    }
}

struct ItemFramePreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGRect] = [:]
    
    static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}


public struct DragToSelect<Data, Content>: View
where Data: RandomAccessCollection,
      Data.Element: Identifiable,
      Data.Index == Int,
      Content: View {
    
    let items: Data
    let accentColour: Color
    let content: (Data.Element, Bool) -> Content
    
    @State private var selectedItemIDs: Set<AnyHashable> = []
    @State private var itemFrames: [AnyHashable: CGRect] = [:]
    @State private var selectionRect: CGRect = .zero
    @State private var isDragging: Bool = false
    @State private var lastSelectedItem: Data.Element?
    
    @State private var geometrySize: CGSize = .zero
    
    
    @State private var scrollOffset: CGFloat = 0
    
    @State private var lastDragLocation: CGPoint?
    
    public init(
        items: Data,
        accentColour: Color = .blue,
        @ViewBuilder content: @escaping (Data.Element, Bool) -> Content
    ) {
        self.items = items
        self.accentColour = accentColour
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color.clear
                    .contentShape(Rectangle())
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        let isSelected = selectedItemIDs.contains(AnyHashable(item.id))
                        content(item, isSelected)
                            .border(Color.blue.opacity(0.3))
                            .modifier(CaptureItemFrame(id: AnyHashable(item.id)))
                    }
                    
                    
                } // END interior vstack
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                
                if isDragging {
                    Rectangle()
                        .fill(accentColour.opacity(0.2))
                        .border(accentColour)
                        .frame(width: selectionRect.width, height: selectionRect.height)
                        .position(
                            x: max(selectionRect.width / 2, min(selectionRect.midX, geometrySize.width - selectionRect.width / 2)),
                            y: max(selectionRect.height / 2, min(selectionRect.midY, geometrySize.height - selectionRect.height / 2))
                        )
                }

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .coordinateSpace(name: "listContainer")
            .task(id: geometry.size) {
                geometrySize = geometry.size
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        lastDragLocation = value.location
                        updateSelectionRect(start: value.startLocation, current: value.location)
                        updateSelectedItems()
                    }
                    .onEnded { _ in
                        isDragging = false
                        selectionRect = .zero
                        //                        stopAutoScroll()
                    }
            )
            
        }
        .onPreferenceChange(ItemFramePreferenceKey.self) { frames in
            self.itemFrames = frames
        }
    }
}

public extension DragToSelect {
    
    private func updateSelectionRect(start: CGPoint, current: CGPoint) {
        let minX = max(0, min(start.x, current.x))
        let maxX = min(geometrySize.width, max(start.x, current.x))
        let minY = max(0, min(start.y, current.y))
        let maxY = min(geometrySize.height, max(start.y, current.y))
        
        selectionRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    //
    //    private func handleItemTap(_ item: Data.Element) {
    //        let itemID = AnyHashable(item.id)
    //        if selectedItemIDs.contains(itemID) {
    //            selectedItemIDs.remove(itemID)
    //        } else {
    //            selectedItemIDs.insert(itemID)
    //        }
    //    }
    
    private func updateSelectedItems() {
        selectedItemIDs = Set(itemFrames.filter { _, frame in
            frame.intersects(selectionRect.offsetBy(dx: 0, dy: scrollOffset))
        }.keys)
    }
    
}
