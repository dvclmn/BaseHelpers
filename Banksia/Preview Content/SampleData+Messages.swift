//
//  SampleData+GPTResponse.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import Foundation

extension Message {
    static let prompt_01 = Message(timestamp: Date().addingTimeInterval(-600), content: """
    Thanks, this looks on the right track. I'd like to remind you, I mentioned I am building this app for MacOS. Please adjust your example to accommodate this. Thanks!
    """, conversation: .plants)
    
    static let prompt_02 = Message(timestamp: Date().addingTimeInterval(-580), content: """
    So far, I am planning to have a `@Model` class `Conversation`, which will be like a main container, for most other data, such as `UserPrompt` and `GPTResponse`, which only have meaning INSIDE a conversation.
    """, conversation: .plants)
    
    static let prompt_03 = Message(timestamp: Date().addingTimeInterval(-560), content: """
    I am finding that the Boolean for `zoomClampActive` is firing even when I am *at* the lowest, and I click to zoom in. The icons will wiggle then, even though I am clicking upwards, which should be seen as *within* the clamp (i.e., a permissible action). Can you spot why this is happening?
    """, conversation: .plants)
    
    
    static let response_01 = Message(timestamp: Date().addingTimeInterval(-590), content: """
    1. *Parent-Child Relationship:* Since you're planning to have the Conversation class as the main container, ensure that each UserPrompt and GPTResponse has a reference to its parent Conversation. This helps maintain the context of each entry and makes it easier to query all related prompts and responses for a given conversation.
    2. *Handling Edits and Deletions:* Consider how your model will handle edits or deletions. If a user edits a prompt or a response, how will this affect the sequence? Will you keep a history of changes, or will the edit simply replace the original?
    3. *Consistency and Integrity:* Ensure that the sequence of prompts and responses remains consistent and integral, especially if your application allows concurrent interactions or modifications to the conversation.
    """, type: .assistant, conversation: .plants)
    
    static let response_02 = Message(timestamp: Date().addingTimeInterval(-570), content: """
    ```swift
    func clampZoomLevel(isZoomIn: Bool) -> CGFloat {
        let increment = isZoomIn ? zoomIncrement : -zoomIncrement
        let newZoomLevel = currentZoomLevel + increment
        let clampedZoomLevel = min(max(newZoomLevel, zoomMin), zoomMax)

        // Check if clamping has occurred
        if isZoomIn {
            // Zooming in
            zoomClampActive = newZoomLevel > clampedZoomLevel || currentZoomLevel >= zoomMax
        } else {
            // Zooming out
            zoomClampActive = newZoomLevel < clampedZoomLevel || currentZoomLevel <= zoomMin
        }

        print(zoomClampActive.description)

        return clampedZoomLevel
    }
    ```
    
    In this updated function:

    The increment is determined based on whether the user is zooming in or out.
    The zoomClampActive is set to true if the new zoom level is outside the clamped range or if the currentZoomLevel is already at the zoomMin or zoomMax.
    This approach should ensure that zoomClampActive is set to true every time the user attempts to zoom beyond the allowed range, including when already at the minimum or maximum zoom level.
    """, type: .assistant, conversation: .plants)
    static let response_03 = Message(timestamp: Date().addingTimeInterval(-550), content: """
    The issue you're encountering with `zoomClampActive` being set to `true` even when the action is within the clamp's permissible range is likely due to how the comparison is made in the `clampZoomLevel` function. Specifically, the issue arises because the comparison checks if the clamped value is different from the new value, without considering the direction of the change (zooming in or out).

    To resolve this, you need to adjust the logic to consider the direction of the zoom increment. Here's how you can modify the clampZoomLevel function.
    """, type: .assistant, conversation: .plants)
    static let response_04 = Message(timestamp: Date().addingTimeInterval(-550), content: """
    To address the issue of text wrapping and view sizing in your SwiftUI macOS application, you need to ensure that the `NSTextView` properly reports its size to the SwiftUI layout system. The problem you're experiencing with `maxWidth: .infinite` not constraining the view to the parent's width is likely due to the intrinsic content size calculation in your `NSTextView` subclass.

    Here’s an updated approach to handle the sizing of your `NSTextView` within SwiftUI:

    ### Step 1: Update the `intrinsicContentSize` in `StylableTextEditor`
    You need to modify the `intrinsicContentSize` to ensure that it respects the available width, especially when `maxWidth: .infinite` is set. This involves calculating the height of the text when it is constrained to a particular width.

    ```swift
    class StylableTextEditor: NSTextView {
        override var intrinsicContentSize: NSSize {
            guard let layoutManager = self.layoutManager, let container = self.textContainer else {
                return super.intrinsicContentSize
            }
            
            container.containerSize = NSSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            layoutManager.ensureLayout(for: container)
            
            let rect = layoutManager.usedRect(for: container)
            return NSSize(width: NSView.noIntrinsicMetric, height: rect.height)
        }
    }
    ```

    ### Step 2: Update the SwiftUI wrapper to handle resizing
    Ensure that the SwiftUI view wrapper for your `NSTextView` properly updates the frame of the `NSTextView` when the SwiftUI view's frame changes. This can be done by updating the `updateNSView` method:

    ```swift
    func updateNSView(_ nsView: StylableTextEditor, context: Context) {
        nsView.string = text // ensure the text is up-to-date
        nsView.frame = CGRect(origin: .zero, size: context.coordinator.size)
        nsView.needsLayout = true
    }
    ```

    ### Step 3: Coordinator for size updates
    Use a Coordinator to handle size updates and communicate them back to SwiftUI, if necessary.

    ```swift
    class Coordinator {
        var size = CGSize(width: 0, height: 0)
        
        func updateSize(_ newSize: CGSize) {
            size = newSize
            // You can use this method to update the state in SwiftUI if needed
        }
    }
    ```

    ### Step 4: Adjust SwiftUI view settings
    Make sure that your SwiftUI view that hosts this `NSViewRepresentable` properly sets the frame or uses `.fixedSize()` if you want to ignore the parent's constraints:

    ```swift
    struct MyTextViewWrapper: View {
        var body: some View {
            MyNSTextViewRepresentable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    ```

    This setup should help ensure that the `NSTextView` respects the width constraints provided by SwiftUI and wraps the text accordingly. Make sure to test these changes thoroughly to see how they affect the layout in different scenarios.
    """)
}
