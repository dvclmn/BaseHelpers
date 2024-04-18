//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ConversationHandler {
    
    let bk = BanksiaHandler()
    let pref = Preferences()
    
    var searchText: String = ""
    var isSearching: Bool = false
    
    var isTesting: Bool = true
    
    var isResponseLoading: Bool = false
    
    var isRequestingNewConversation: Bool = false
    
    var selectedParagraph: String = ""
    
    /// This history should only be sent to GPT, not be saved to a Conversation. The Conversation has it's own array of Messages
    var messageHistory: String = ""
    
    
    func createMessageHistory(for conversation: Conversation, latestMessage: Message) async {
        
        guard let messages = conversation.messages, !messages.isEmpty else {
            messageHistory = ""
            print("No message in conversation")
            return
        }
        
        let sortedMessages = messages.sorted { $0.timestamp > $1.timestamp }
        
        let maxMessageContextCount: Int = 8
        
        let queryID: String = latestMessage.persistentModelID.hashValue.description
        
        let historicalMessages: [Message] = sortedMessages.suffix(maxMessageContextCount).dropLast() /// Drop last, to exclude the message I *just* sent
        
        let queryHeading: String = "\n\n# |---- BEGIN Query #\(queryID) ----> \n"
        let latestQueryDecorator: String = "## Latest Query\n"
        let latestMessageFormatted: String = "\(formatMessageForGPT(latestMessage))\n\n"
        let conversationHistoryDecorator: String = "## Conversation History\n"
        let historyFormatted: String = historicalMessages.map { formatMessageForGPT($0) }.joined(separator: "BUTTS \n")
        let queryFooter: String = "\n# >---- END Query #\(queryID) ----|\n\n"
        
        
        
        
        messageHistory = """
        \(queryHeading)
        \(latestQueryDecorator)
        \(latestMessageFormatted)
        \(conversationHistoryDecorator)
        \(historyFormatted)
        \(queryFooter)
        """
        
        print(messageHistory)
        
    } // END createMessageHistory
    
    func getRandomParagraph() -> String {
        TestResponses.paragraphs.randomElement() ?? "No paragraphs available"
    }
    
    
    func fetchGPTResponse(for conversation: Conversation) async throws -> Message {
        print("|--- fetchGPTResponse --->")
        do {
            
            var responseMessage: Message
            
            if !isTesting {
                let gptResponse: GPTReponse = try await fetchGPTResponse(prompt: messageHistory)
                print("Received GPT response")
                
                guard let firstMessage = gptResponse.choices.first else {
                    throw GPTError.couldNotGetLastResponse
                    
                }
                print("Retrieved last message")
                
                responseMessage = Message(content: firstMessage.message.content, type: .assistant, conversation: conversation)
            } else {
                responseMessage = Message(content: getRandomParagraph(), type: .assistant, conversation: conversation)
            }
            
            print(">--- END fetchGPTResponse ---|\n")
            return responseMessage
            
        } catch {
            throw GPTError.failedToFetchResponse
        }
    }
    
    func createMessage(_ response: String, with type: MessageType, for conversation: Conversation) -> Message {
        print("|--- createMessage --->")
        
        let newMessage = Message(
            content: response,
            type: type,
            conversation: conversation
        )
        print(">--- END createMessage ---|\n")
        return newMessage
    }
    
    
    func formatMessageForGPT(_ message: Message) -> String {
        print("|--- formatMessageForGPT --->")
        
        let messageBegin: String = "\n\n# |--- BEGIN Message ---> \n"
        let timeStamp: String = "Timestamp: \(Date.now)"
        let type: String = "Author: \(message.type.name)"
        let conversationID: String = "Conversation ID: \(message.conversation?.persistentModelID.hashValue.description ?? "No Conversation ID")"
        let content: String = "Message:\n\(message.content)"
        let messageEnd: String = "\n# >--- END Message ---|\n\n"
        
        let formattedMessage: String = """
        \(messageBegin)
        \(timeStamp)
        \(type)
        \(conversationID)
        \(content)
        \(messageEnd)
        """
        print(">--- END formatMessageForGPT ---|\n")
        return formattedMessage
    }
    
}

enum ConversationState {
    case blank
    case none
    case single
    case multiple
    
    init(totalConversations: Int, selectedConversation: Set<Conversation.ID>) {
        if totalConversations == 0 {
            self = .blank
        } else {
            switch selectedConversation.count {
            case 0:
                self = .none
            case 1:
                self = .single
            default:
                self = .multiple
            }
        } // END empty conversations check
    } // END init
    
    var emoji: [String] {
        switch self {
        case .blank:
            return ["🕸️", "🎃", "🌴", "🌵"]
        case .none:
            return ["🫧", "👠", "🪨", "🪸", "🕳️"]
        case .single:
            return []
        case .multiple:
            return ["💃", "🪶", "🐝", "🍌", "🦎"]
        }
    } // END emoji
    
    var title: [String] {
        switch self {
        case .blank:
            return [
                "Begin a new conversation",
                "Time to start a chat",
                "No conversations here"
            ]
        case .none:
            return [
                "Nothing selected",
                "No conversations selected",
                "Select a conversation"
            ]
        case .single:
            return []
        case .multiple:
            return [
                "Multiple conversations",
                "Multiple chats selected",
                "A few conversations selected"
            ]
        }
    } // END title
    
    var message: [String] {
        switch self {
        case .blank:
            return [
                "You have no conversations. Create a new one to get started.",
                "It's as good a time as any to create a conversation."
            ]
        case .none:
            return [
                "Make a selection from the list in the sidebar.",
                "You can pick something from the sidebar on the left."
            ]
        case .single:
            return []
        case .multiple:
            return [
                "You can delete them, or select other options from the toolbar above."
            ]
        }
    } // END title
    
    func randomEmoji() -> String {
        self.emoji.randomElement() ?? ""
    }
    func randomTitle() -> String {
        self.title.randomElement() ?? ""
    }
    func randomMessage() -> String {
        self.message.randomElement() ?? ""
    }
    
} // END coversation state


struct TestResponses {
    static let paragraphs: [String] = [
        """
        Could you come up with a function for me, for SwiftUI, that will generate a paragraph or two, with some tweakable parameters for paragprah count, and word count? I dont mind what the words are, they jsut need to look like natural language. Feel free to even supply actual static blocks of strings — actually let’s do that. I will build a library of parapgraphcs, as `[String]`, and can you write me up a function that simply selects one of the paragraphis (i.e. items in the array), and returns it?
        """,
        """
        ```swift
        import SwiftUI
        
        struct TextView: NSViewRepresentable {
            var text: NSAttributedString
        
            func makeNSView(context: Context) -> NSTextView {
                let textView = NSTextView()
                textView.isEditable = false
                textView.isSelectable = false
                return textView
            }
        
            func updateNSView(_ nsView: NSTextView, context: Context) {
                nsView.textStorage?.setAttributedString(text)
            }
        }
        
        struct ContentView: View {
            var body: some View {
                TextView(text: NSAttributedString(string: "Hello, SwiftUI!"))
                    .frame(width: 300, height: 100)
            }
        }
        ```
        
        This approach allows you to maintain the rich text capabilities of `NSTextView` while integrating it into a modern SwiftUI interface.
        """,
        """
        ### Considerations:
        - **Performance**: If your app needs to display a large number of messages or very frequent updates, consider the performance implications of using `NSTextView`, as it might be heavier than simpler views like `Text` in SwiftUI.
        - **Consistency**: Using the same component (`NSTextView`) across your app for both input and display can lead to a more consistent implementation and styling approach.
        - **Integration with SwiftUI**: If you are using SwiftUI and need to integrate `NSTextView`, you can use `NSViewRepresentable` to wrap `NSTextView` for use within SwiftUI views.
        
        """,
        
        """
        Using `NSTextView` in your macOS app for both input and display of messages can be a viable option, especially if you want to leverage its rich text capabilities and the ability to use attributed strings for advanced styling. Here are some considerations and steps for using `NSTextView` as a read-only component for displaying messages:
        
        ### Advantages of Using `NSTextView`:
        1. **Rich Text Features**: `NSTextView` supports rich formatting options, which can be beneficial if you want to display messages with varied styles or embedded links.
        2. **Attributed Strings**: Since you already have a library for regex-driven attributed strings, `NSTextView` can directly utilize these, allowing for consistent text styling across your application.
        3. **Customization**: `NSTextView` offers extensive customization options, which can be tailored to fit the look and feel of your app.
        
        ### Making `NSTextView` Read-Only:
        To use `NSTextView` for displaying static messages, you need to configure it to be non-editable and non-selectable if you don't want users to interact with the text beyond reading:
        
        """,
        
        """
        ### Key Points:
        
        1. **Regex Pattern**: The pattern `"`.*?`"` is used to match text including the backticks.
        2. **Attributed String**: We create an `AttributedString` from the plain text and apply attributes to parts of the text that match the regex pattern.
        3. **Styling**: The text within backticks, including the backticks themselves, is styled with the specified attributes (red color and bold font in this case).
        
        This approach allows you to include and style the backticks along with the text they enclose, directly within your SwiftUI view.
        """,
        """
        Thanks!
        
        Could you explain 'non-greedy’?
        
        Also, how would you suggest i could *include* the backticks, so they are caught in the styled attributed string?
        """,
        """
        1. **Regular Expression**: The pattern `("```\\n)(.*?)(\\n```")` is used to match blocks of text that start and end with triple backticks, considering the line breaks. It uses `.*?` for non-greedy matching of any characters between the backticks, including new lines due to the `.dotMatchesLineSeparators` option.
        
        2. **Text Attributes**: The code applies several attributes to the matched text:
           - `.foregroundColor`: Changes the text color inside the code blocks.
           - `.font`: Applies a monospaced font to make code more readable.
           - `.backgroundColor`: Adds a background color to highlight the code block.
        
        3. **Safe Updating**: It preserves the user's selected text range before and after applying the styles, which is crucial for maintaining the text view's state.
        
        This function should be called in appropriate places, such as after the text changes in the `NSTextView`. This way, it will style the code blocks dynamically as the user types or modifies the existing text.
        """,
        """
        The issue with the cursor jumping to the end of the text in your `StylableTextEditor` appears to be related to how the text is being updated in the `updateNSView` method of your `NSViewRepresentable` implementation. Every time the text changes and you set `textView.string = text`, the cursor position (caret) is reset to the end of the text.
        
        To fix this, you need to preserve the cursor position before updating the text and restore it afterward. Here’s how you can adjust your `updateNSView` method:
        
        ```swift
        func updateNSView(_ textView: StylableTextEditor, context: Context) {
            let selectedRange = textView.selectedRange() // Save the current selected range
            if textView.string != text {
                textView.string = text
                textView.invalidateIntrinsicContentSize()
                textView.applyStyles()
            }
            textView.setSelectedRange(selectedRange) // Restore the selected range
        }
        ```
        
        This modification ensures that the cursor position is saved before the text is updated and then restored to its original position, preventing it from jumping to the end after each character is typed.
        
        This approach assumes that the text changes are not dramatically altering the structure of the text (e.g., inserting or deleting large blocks of text in positions before the cursor), which would require more complex handling of the cursor position. For typical text editing, this should work effectively.
        """,
        """
        Could you start me off by providing code for the following requirement:
        
        I would like to style code within three backticks like ```, followed by a line break, then the body of the code, finally another line break and the last set of three backticks. This is, of course, a typical markdown syntax, to  facilitate the styling of code blocks.
        
        Can you provide a solution for the in the function below?
        
        ```
        func applyStyles() {
                
                let selectedRange = selectedRange()
                
                let text = NSMutableAttributedString(string: self.string)
                // Example regex pattern for demonstration
                let regex = try! NSRegularExpression(pattern: "\\b[\\w]+\\b", options: [])
                let range = NSRange(location: 0, length: text.length)
                
                regex.enumerateMatches(in: self.string, options: [], range: range) { match, _, _ in
                    if let matchRange = match?.range {
                        text.addAttribute(.foregroundColor, value: NSColor.blue, range: matchRange)
                    }
                }
                
                self.textStorage?.setAttributedString(text)
                
                setSelectedRange(selectedRange) // Restore the selected range
            }
        ```
        
        
        """,
        """
        The issue with the cursor jumping to the end of the text in your `StylableTextEditor` appears to be related to how the text is being updated in the `updateNSView` method of your `NSViewRepresentable` implementation. Every time the text changes and you set `textView.string = text`, the cursor position (caret) is reset to the end of the text.
        
        To fix this, you need to preserve the cursor position before updating the text and restore it afterward. Here’s how you can adjust your `updateNSView` method:
        
        ```swift
        func updateNSView(_ textView: StylableTextEditor, context: Context) {
            let selectedRange = textView.selectedRange() // Save the current selected range
            if textView.string != text {
                textView.string = text
                textView.invalidateIntrinsicContentSize()
                textView.applyStyles()
            }
            textView.setSelectedRange(selectedRange) // Restore the selected range
        }
        ```
        
        This modification ensures that the cursor position is saved before the text is updated and then restored to its original position, preventing it from jumping to the end after each character is typed.
        
        This approach assumes that the text changes are not dramatically altering the structure of the text (e.g., inserting or deleting large blocks of text in positions before the cursor), which would require more complex handling of the cursor position. For typical text editing, this should work effectively.
        """
    ]
}
