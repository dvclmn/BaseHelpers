//
//  File.swift
//
//
//  Created by Dave Coleman on 25/7/2024.
//

import SwiftUI


enum ScrollDirection {
    case up, down
}

struct CaptureItemFrame<Data: Identifiable>: ViewModifier {
    let item: Data
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: ItemFramePreferenceKey.self,
                    value: [AnyHashable(item.id): geometry.frame(in: .named("listContainer"))]
                )
            })
    }
}

struct AnyIdentifiable: Identifiable {
    let id: AnyHashable
    
    init<T: Identifiable>(_ value: T) {
        self.id = AnyHashable(value.id)
    }
}

struct ItemFramePreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGRect] = [:]
    
    static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}


struct DragToSelect<Data, Content>: View where Data: Identifiable & Hashable, Content: View {
    
    @State private var selectedItems: Set<Data> = []
    @State private var itemFrames: [AnyHashable: CGRect] = [:]
    @State private var selectionRect: CGRect = .zero
    @State private var isDragging: Bool = false
    @State private var lastSelectedItem: Data?
    
    @State private var scrollOffset: CGFloat = 0
    
    @State private var autoScrollTimer: Timer?
    @State private var lastDragLocation: CGPoint?
    
    
    
    let items: [Data]
    let content: (Data) -> Content
    
    init(
        items: [Data],
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.items = items
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        ForEach(items) { item in
                            content(item)
                                .padding(8)
                                .background(selectedItems.contains(item) ? Color.blue.opacity(0.3) : Color.clear)
                                .modifier(CaptureItemFrame(item: item))
                            //                                .onTapGesture(count: 1) {
                            //                                    handleItemTap(item)
                            //                                }
                        }
                        
                    } // END interior vstack
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(GeometryReader { proxy in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
                    })
                    .border(Color.orange.opacity(0.3))
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                
                if isDragging {
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .border(Color.blue)
                        .frame(width: selectionRect.width, height: selectionRect.height)
                        .position(x: selectionRect.midX, y: selectionRect.midY)
                }
            }
            .coordinateSpace(name: "listContainer")
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        lastDragLocation = value.location
                        updateSelectionRect(start: value.startLocation, current: value.location)
                        updateSelectedItems()
                        startAutoScrollIfNeeded(geometry: geometry)
                    }
                    .onEnded { _ in
                        isDragging = false
                        selectionRect = .zero
                        stopAutoScroll()
                    }
            )
            
        }
        .onPreferenceChange(ItemFramePreferenceKey.self) { frames in
            self.itemFrames = frames
        }
        .border(Color.green.opacity(0.3))

    }
}

extension DragToSelect {
    
    private func startAutoScrollIfNeeded(geometry: GeometryProxy) {
        guard let location = lastDragLocation else { return }
        let threshold: CGFloat = 50
        
        if location.y < threshold {
            startAutoScroll(direction: .up)
        } else if location.y > geometry.size.height - threshold {
            startAutoScroll(direction: .down)
        } else {
            stopAutoScroll()
        }
    }
    
    private func startAutoScroll(direction: ScrollDirection) {
        stopAutoScroll()
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            let scrollAmount: CGFloat = 5
            let newOffset = direction == .up ? scrollOffset + scrollAmount : scrollOffset - scrollAmount
            scrollOffset = newOffset
            
            if let location = lastDragLocation {
                updateSelectionRect(start: selectionRect.origin, current: CGPoint(x: location.x, y: location.y - scrollOffset))
                updateSelectedItems()
            }
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    //    private func handleItemTap(_ item: String) {
    //        if NSEvent.modifierFlags.contains(.command) {
    //            if selectedItems.contains(item) {
    //                selectedItems.remove(item)
    //            } else {
    //                selectedItems.insert(item)
    //            }
    //        } else if NSEvent.modifierFlags.contains(.shift), let lastSelected = lastSelectedItem {
    //            let range = getItemRange(from: lastSelected, to: item)
    //            selectedItems = Set(range)
    //        } else {
    //            selectedItems = [item]
    //        }
    //        lastSelectedItem = item
    //    }
    
    //    private func getItemRange(from: String, to: String) -> [String] {
    //        guard let fromIndex = items.firstIndex(of: from),
    //              let toIndex = items.firstIndex(of: to) else {
    //            return []
    //        }
    //        return Array(items[min(fromIndex, toIndex)...max(fromIndex, toIndex)])
    //    }
    
    private func updateSelectionRect(start: CGPoint, current: CGPoint) {
        let minX = min(start.x, current.x)
        let maxX = max(start.x, current.x)
        let minY = min(start.y, current.y)
        let maxY = max(start.y, current.y)
        
        selectionRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    private func updateSelectedItems() {
        selectedItems = Set(itemFrames.filter { _, frame in
            frame.intersects(selectionRect.offsetBy(dx: 0, dy: scrollOffset))
        }.compactMap { key, _ in
            items.first(where: { AnyHashable($0.id) == key })
        })
    }
    
    
    //    private func updateSelectedItems() {
    //        selectedItems = Set(itemFrames.filter { _, frame in
    //            frame.intersects(selectionRect.offsetBy(dx: 0, dy: scrollOffset))
    //        }.keys)
    //    }
    
    
}
