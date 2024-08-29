//
//  MultiSelect.swift
//
//
//  Created by Dave Coleman on 23/5/2024.
//

import Foundation
import SwiftUI

#if os(macOS)


@Observable
public class MultiSelect<Item: Identifiable> {
    public var selectedItems = Set<Item.ID>()
    public var lastSelectedItem: Item.ID?
    
    public init() {}
    
    public func toggleSelection(for itemID: Item.ID) {
        if selectedItems.contains(itemID) {
            selectedItems.remove(itemID)
        } else {
            selectedItems.insert(itemID)
        }
    }
    
    public func selectSingle(itemID: Item.ID) {
        selectedItems = [itemID]
    }
    
    public func selectRange(from startID: Item.ID, to endID: Item.ID, in allItems: [Item]) {
        guard let startIndex = allItems.firstIndex(where: { $0.id == startID }),
              let endIndex = allItems.firstIndex(where: { $0.id == endID }) else {
            return
        }
        
        let range = min(startIndex, endIndex)...max(startIndex, endIndex)
        let rangeIDs = allItems[range].map { $0.id }
        selectedItems.formUnion(rangeIDs)
    }
}


public struct MultiSelectModifier<Item: Identifiable>: ViewModifier {
    
    @State private var multiSelect = MultiSelect<Item>()
    var item: Item
    var displayedItems: [Item]
    var rounding: Double
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                SimultaneousGesture(
                    ExclusiveGesture(
                        TapGesture(count: 1).modifiers(.command).onEnded {
                            multiSelect.toggleSelection(for: item.id)
                        },
                        TapGesture(count: 1).modifiers(.shift).onEnded {
                            if let lastSelectedItem = multiSelect.lastSelectedItem {
                                multiSelect.selectRange(from: lastSelectedItem, to: item.id, in: displayedItems)
                            } else {
                                multiSelect.toggleSelection(for: item.id)
                            }
                            multiSelect.lastSelectedItem = item.id
                        }
                    ),
                    TapGesture(count: 1).onEnded {
                        multiSelect.selectSingle(itemID: item.id)
                        multiSelect.lastSelectedItem = item.id
                    }
                )
            ) // END gestures
        
            .overlay {
                if multiSelect.selectedItems.contains(item.id) {
                    RoundedRectangle(cornerRadius: rounding)
                        .fill(.clear)
                        .stroke(Color.accentColor, lineWidth: 3)
                }
            }
    }
}

public extension View {
    func multiSelect<Item: Identifiable>(
        item: Item,
        displayedItems: [Item],
        rounding: Double = 10
    ) -> some View {
        self.modifier(
            MultiSelectModifier(
                item: item,
                displayedItems: displayedItems,
                rounding: rounding
            )
        )
    }
}
#endif
