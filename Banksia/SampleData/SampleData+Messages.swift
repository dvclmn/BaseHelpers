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
    """, isUser: false, conversation: .plants)
    
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
    """, isUser: false, conversation: .plants)
    static let response_03 = Message(timestamp: Date().addingTimeInterval(-550), content: """
    The issue you're encountering with `zoomClampActive` being set to `true` even when the action is within the clamp's permissible range is likely due to how the comparison is made in the `clampZoomLevel` function. Specifically, the issue arises because the comparison checks if the clamped value is different from the new value, without considering the direction of the change (zooming in or out).

    To resolve this, you need to adjust the logic to consider the direction of the zoom increment. Here's how you can modify the clampZoomLevel function.
    """, isUser: false, conversation: .plants)
}

