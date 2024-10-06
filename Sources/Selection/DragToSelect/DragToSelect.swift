//
//  File.swift
//
//
//  Created by Dave Coleman on 25/7/2024.
//

import SwiftUI
//import Shortcuts
import Geometry
import Scrolling
import BaseHelpers

#if os(macOS)

public struct DragToSelect<Data, Content>: View
where Data: RandomAccessCollection,
      Data.Element: Identifiable,
      Data.Index == Int,
      Content: View {
  
  public typealias Output = (_ item: Data.Element, _ isSelected: Bool, _ position: SelectionPosition?) -> Content
  
  //    @Environment(\.modifierKeys) private var modifierKeys
  
  let items: Data
  @Binding var selectedItemIDs: Set<Data.Element.ID>
  let isSelectionEnabled: Bool
  let verticalSpacing: CGFloat
  let clipProofPadding: CGFloat
  let accentColour: Color
  let content: Output
  
  
  /// A dictionary that keeps track of the frame bounds and ID, for each selectable item
  @State private var itemFrames: [Data.Element.ID: CGRect] = [:]
  @State private var selectionRect: CGRect = .zero
  @State private var isDragging: Bool = false
  @State private var lastSelectedItem: Data.Element?
  @State private var geometrySize: CGSize = .zero
  @State private var lastDragLocation: CGPoint?
  
  @State private var initialSelection = Set<Data.Element.ID>()
  
  public init(
    items: Data,
    selectedItemIDs: Binding<Set<Data.Element.ID>>,
    isSelectionEnabled: Bool = true,
    verticalSpacing: CGFloat = 0,
    clipProofPadding: CGFloat = 2,
    accentColour: Color = .blue,
    @ViewBuilder content: @escaping Output
  ) {
    self.items = items
    self._selectedItemIDs = selectedItemIDs
    self.isSelectionEnabled = isSelectionEnabled
    self.verticalSpacing = verticalSpacing
    self.clipProofPadding = clipProofPadding
    self.accentColour = accentColour
    self.content = content
  }
  
  public var body: some View {
    
    VStack(alignment: .leading, spacing: verticalSpacing) {
      ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
        
        let isSelected = selectedItemIDs.contains(item.id)
        
        let position = selectedItemIDs.selectionPosition(
          for: item.id,
          idForElement: { $0 },
          in: sortedIDs,
          isPreviousSelected: { selectedItemIDs.contains($0) },
          isNextSelected: { selectedItemIDs.contains($0) }
        )

        content(item, isSelected, position)
          .padding(clipProofPadding)
          .modifier(CaptureItemFrame(id: item.id))
      }
      Spacer()
    } // END interior vstack
//    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    
    /// > Note
    /// If ugly clipping is occuring around this view, that's likely because
    /// of this scrollview. Add some padding to clear the clipped elements
    /// away from the very edges, if possible.
    ///
    .scrollWithOffset(maskMode: .mask, edgePadding: 4, showsIndicators: false)
//    .scrollWithOffset(maskMode: .overlay, isClipDisabled: true)
    .contentShape(Rectangle())
    .coordinateSpace(name: "listContainer")
    .gesture(dragGesture)
    //        .highPriorityGesture(dragGesture)
    .onPreferenceChange(ItemFramePreferenceKey<Data.Element.ID>.self) { frames in
      self.itemFrames = frames
    }
    //        .readModifierKeys()
    .readSize { size in
      self.geometrySize = size
    }
    .overlay {
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
    
    
  }
}

public extension DragToSelect {
  
  var sortedIDs: [Data.Element.ID] {
    items.map { $0.id }
  }
  
  private func updateSelectionRect(start: CGPoint, current: CGPoint) {
    let minX = max(0, min(start.x, current.x))
    let maxX = min(geometrySize.width, max(start.x, current.x))
    let minY = max(0, min(start.y, current.y))
    let maxY = min(geometrySize.height, max(start.y, current.y))
    
    selectionRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
  }
  
  private func updateSelectedItems() {
    let threshold: CGFloat = 1
    
    let selectionFilter = itemFrames.filter { item, frame in

      frame.insetBy(dx: -threshold, dy: -threshold).intersects(selectionRect)      
      
    }
    
    let compactedSelection = selectionFilter.compactMap { key, _ in
      key
    }
    
    let newSelection = Set(compactedSelection)
    
    //        if modifierKeys.contains(.command) {
    //            if modifierKeys.contains(.shift) {
    //                // If Command and Shift are pressed, remove the new selection from the existing selection
    //                selectedItemIDs.subtract(newSelection)
    //            } else {
    //                // If only Command is pressed, add new items to the selection without removing any
    //                selectedItemIDs.formUnion(newSelection)
    //            }
    //        } else {
    // If neither Command nor Shift is pressed, replace the selection
    selectedItemIDs = newSelection
    //        }
  }
  
  
  private var dragGesture: some Gesture {
    DragGesture(minimumDistance: 6)
      .onChanged { value in
        if isSelectionEnabled {
          if !isDragging {
            initialSelection = selectedItemIDs
          }
          isDragging = true
          lastDragLocation = value.location
          
          /// This handles the actual drawing of the bounding shape
          updateSelectionRect(start: value.startLocation, current: value.location)
          updateSelectedItems()
        }
      }
      .onEnded { _ in
        if isSelectionEnabled {
          isDragging = false
          selectionRect = .zero
          initialSelection = []
        }
      }
  }
  
}

struct CaptureItemFrame<ID: Hashable>: ViewModifier {
  let id: ID
  
  func body(content: Content) -> some View {
    content
      .background(GeometryReader { geometry in
        Color.clear.preference(
          key: ItemFramePreferenceKey<ID>.self,
          value: [id: geometry.frame(in: .named("listContainer"))]
        )
      })
  }
}

struct ItemFramePreferenceKey<ID: Hashable>: PreferenceKey {
  static var defaultValue: [ID: CGRect] {
    get { [:] }
  }
  
  static func reduce(value: inout [ID: CGRect], nextValue: () -> [ID: CGRect]) {
    value.merge(nextValue()) { $1 }
  }
}

#endif
