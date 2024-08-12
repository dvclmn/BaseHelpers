//
//  TestStrings.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//


//
//  BigText.swift
//  macOS Application
//
//  Created by Matthew Davidson on 19/12/19.
//  Copyright © 2019 Matt Davidson. All rights reserved.
//

import Foundation

public struct TestStrings {
    
    public static let smallCodeBlock: String = """
    
    ```
    
    let highlightr = Highlightr()
    highlightr?.setTheme(to: "xcode-dark-butts")
    
    ```
    
    And then these words here. If you would like to `contribute to the development` of Highlightr, please follow the guidelines outlined in the CONTRIBUTING.md file in the GitHub repository.
    
    ```swift
    
    # Python program to find the sum of natural using recursive function ram to find the sum of natural using recursive function ram to find the sum of natural using recursive function ram to find the sum of natural using recursive function
    
    def recur_sum(n):
    if n <= 1:
    ```
    """
    
    public static let conversationTitles: [String] = [
        "Swift programming",
        "Chat with friends",
        "Daily updates",
        "Project discussion",
        "Meeting notes",
        "Lunch plans",
        "Code review",
        "Movie night",
        "Game night",
        "Weekend getaway",
        "Book club",
        "Team sync",
        "Design brainstorm",
        "Shopping list",
        "Holiday plans",
        "Birthday party",
        "Fitness goals",
        "Travel itinerary",
        "Dinner recipes",
        "Workout routine",
        "Music playlist",
        "Gardening tips",
        "Tech news",
        "Study group",
        "Language practice"
    ]
    
    public static let paragraphsWithCode: [String] = [
        
        """
        After reviewing your code, I can see a few areas where improvements can be made and why some properties like `labelDisplay` might not be updating correctly. Let's address these issues and suggest some improvements:\n\n1. Repetition between CustomButton and CustomLabel:\n   You're right that there's a lot of repetition. We can solve this by creating a protocol extension for CustomStylable that implements these common methods.\n\n2. Config not updating correctly:\n   The main issue is that you're creating a new instance of the element in each modifier method, but you're not passing the existing configuration to the new instance. This means that each modifier is working on a fresh configuration, losing previous modifications.\n\n3. Improvements and Suggestions:\n\nHere's how we can address these issues:\n\na. Create a protocol extension for CustomStylable:\n\n```swift\npublic extension CustomStylable {\n    func with<T: CustomStylable>(_ modifier: CustomStyleModifiable) -> T {\n        var newElement = self as! T\n        modifier.modify(&newElement)\n        return newElement\n    }\n\n    var iconOnly: Self { with(LabelDisplayModifier(label: .iconOnly)) }\n    var titleOnly: Self { with(LabelDisplayModifier(label: .titleOnly)) }\n    var noBackground: Self { with(BackgroundTypeModifier(backgroundType: .none)) }\n    \n    func config(_ config: ElementConfiguration) -> Self { with(ConfigurationModifier(config: config)) }\n    func size(_ size: ElementSize) -> Self { with(SizeModifier(size: size)) }\n    func label(_ label: LabelDisplay) -> Self { with(LabelDisplayModifier(label: label)) }\n    func emphasis(_ emphasis: ElementEmphasis) -> Self { with(EmphasisModifier(emphasis: emphasis)) }\n    func background(_ type: BackgroundType) -> Self { with(BackgroundTypeModifier(backgroundType: type)) }\n    func tint(_ tint: Color) -> Self { with(TintModifier(tint: tint)) }\n    func layout(_ layout: ElementLayout) -> Self { with(LayoutModifier(layout: layout)) }\n}\n```\n\nb. Update CustomButton and CustomLabel to use this extension:\n\n```swift\npublic struct CustomButton: PrimitiveButtonStyle, CustomStylable {\n    public var config: ElementConfiguration = .default\n    \n    \\/\\/ ... rest of the implementation ...\n}\n\npublic struct CustomLabel: LabelStyle, CustomStylable {\n    public var config: ElementConfiguration = .default\n    \n    \\/\\/ ... rest of the implementation ...\n}\n```\n\nc. For specialized methods like `fullWidth` for CustomButton, you can add them directly to the CustomButton extension:\n\n```swift\npublic extension CustomButton {\n    var fullWidth: CustomButton { self.layout(.fullWidth) }\n}\n```\n\nd. Update the BaseElementStyle to use the config directly:\n\n```swift\npublic struct BaseElementStyle: ViewModifier {\n    let config: ElementConfiguration\n    let strokeWidth: Double\n    \n    public func body(content: Content) -> some View {\n        content\n            .lineLimit(1)\n            .frame(\n                minWidth: config.size.length,\n                maxWidth: config.layout.width,\n                minHeight: config.size.height,\n                maxHeight: config.size.height\n            )\n            .padding(.leading, config.size.paddingLeading)\n            .padding(.trailing, config.size.paddingTrailing)\n            .background(config.emphasis.backgroundColour)\n            .background(config.tint)\n            .background(config.backgroundType.material)\n            .clipShape(.rect(cornerRadius: config.size.rounding))\n            .overlay {\n                if config.backgroundType == .rimlight {\n                    RimLightShape(strokeWidth: strokeWidth) {\n                        RoundedRectangle(cornerRadius: config.size.rounding)\n                    }\n                }\n            }\n    }\n}\n```\n\ne. Ensure that when you're using the custom button or label, you're chaining the modifiers:\n\n```swift\nButton(\"Click me\", action: {})\n    .buttonStyle(.custom.size(.large).emphasis(.strong).iconOnly)\n```\n\nThese changes should address the issues with config not updating
        """,
        
        """
        I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.

        ```
        struct MessageInputView: View {

            @Environment(ConversationHandler.self) private var conv
            @Environment(BanksiaHandler.self) private var bk
            
            @State private var isUIFaded: Bool = false
            
            @State private var isHoveringHeightAdjustor: Bool = false
            @State private var isHoveringControls: Bool = false
            
            var body: some View {
                
                VStack(spacing: 0) {

                    ScrollViewWithOffsetTracking(showsIndicators: false) { offset in
                        withAnimation(.snappy(duration: 0.3)) {
                            isMasked = offset.y < -10
                            if let previous = previousOffset {
                                isScrolling = previous != offset
                            }
                            previousOffset = offset
                        }
                    } content: {
                        
                        VStack(spacing: 0) {
                            MarkdownEditorRepresentable(
                                text: $conv.userPrompt,
                                editorHeight: $conv.editorHeight,
                                isCustomResized: $conv.isCustomResized,
                                handler: conv,
                                focusable: true,
                                isFocused: $localEditorFocus,
                                minHeight: localEditorFocus ? ConversationHandler.defaultEditorHeightInactive : ConversationHandler.defaultEditorHeightInactive,
                                maxHeight: sidebar.windowSize.height * 0.8
                            )
                            .focusable()
                            .focused($isFocused, equals: .editor)
                            .onAppear {
                                isFocused = .editor
                                localEditorFocus = true
                            }
                            .onEscapeKeyDoubleTap {
                                print("Double tapped Escape")
                                localEditorFocus = false
                                isFocused = nil
                            }
                            
                            
                        } // END internal vstack
                        .safeAreaPadding(.top, Styles.sizeMedium)
                        
                    } // END scroll view with offset tracking
                    .scrolllMaask(isMasked, height: 200)
                    
                    .onTapGesture {
                        localEditorFocus = true
                        isFocused = .editor
                    }
                    .task(id: conv.userPrompt) {
                        do {
                            print("`conv.userPrompt was edited`")
                            try await Task.sleep(for: .seconds(3))
                            print("Waited three seconds after last user prompt edit, to save backup to prefs.")
                            pref.userPrompt = conv.userPrompt
                        } catch {
                            print("Trouble sleeping task")
                        }
                    }

                    .task(id: conv.currentRequest) {
                        switch conv.currentRequest {
                        case .focusEditor:
                            isFocused = .editor
                            localEditorFocus = true
                            conv.currentRequest = .none
                        default:
                            break
                        }
                    }
                    
                    .background {
        //                if controlActiveState == .key {
                            Rectangle()
                                .fill(.black.opacity(0.2))
                                .background(.thinMaterial)
        //                } else {
        //                    Color.clear
        //                        .grainient(
        //                            seed: conversation.grainientSeed,
        //                            version: .v3,
        //                            grainOpacity: 0.0,
        //                            blurAmount: 90,
        //                            dimming: bk.uiDimming + 0.2
        //                        )
        //                }
                    }
                    .resizable(
                        height: adjustedEditorHeight,
                        isCustomResized: $conv.isCustomResized,
                        extraHeight: conv.extraEditorHeight,
                        minHeight: localEditorFocus ? ConversationHandler.defaultEditorHeightFocused : ConversationHandler.defaultEditorHeightInactive,
                        maxHeight: sidebar.windowSize.height * 0.6
                    )
                    .border(pref.isShowingFrames ? Color.green.opacity(0.2) : .clear)
        //            .overlay(alignment: .bottom) {
        //                TextStyleControls()
        //            }
                    
                    EditorControls()
                    
                } // END main vstack
                
        ```

        """,
        
        """
        I apologize for the cut-off. Let me continue with the improvements and suggestions:\n\n2. Error Handling: Consider implementing more robust error handling for regex creation. You could create the regular expressions once and store them, rather than creating them each time `styleText` is called.\n\n3. Performance Optimization: If you're dealing with very large documents, you might want to consider implementing a caching mechanism or incremental styling to avoid re-styling the entire document on each edit.\n\n4. Customizability: You could make the styling more flexible by allowing custom styling functions for each syntax type. This would make it easier to add new syntax types or modify existing ones without changing the core styling logic.\n\n5. Syntax Highlighting: For code blocks, you might want to consider implementing syntax highlighting for various programming languages.\n\nHere's an example of how you might implement some of these improvements:\n\n```swift\nclass MarkdownEditor: NSTextView {\n    private var cachedRegexes: [MarkdownSyntax: NSRegularExpression] = [:]\n    \n    override init(frame: NSRect, textContainer: NSTextContainer?) {\n        super.init(frame: frame, textContainer: textContainer)\n        setupRegexes()\n    }\n    \n    required init?(coder: NSCoder) {\n        super.init(coder: coder)\n        setupRegexes()\n    }\n    \n    private func setupRegexes() {\n        for syntax in MarkdownSyntax.allCases {\n            do {\n                cachedRegexes[syntax] = try NSRegularExpression(pattern: syntax.regex.description, options: [])\n            } catch {\n                print(\"Error creating regex for \\(syntax): \\(error)\")\n            }\n        }\n    }\n    \n    private func styleText(for syntax: MarkdownSyntax, in range: NSRange) {\n        guard let textStorage = self.textStorage, let regex = cachedRegexes[syntax] else { return }\n        \n        let string = textStorage.string\n        let searchRange = NSIntersectionRange(range, NSRange(location: 0, length: string.length))\n        \n        regex.enumerateMatches(in: string, options: [], range: searchRange) { match, _, _ in\n            guard let match = match else { return }\n            \n            let (contentRange, startSyntaxRange, endSyntaxRange) = self.calculateRanges(for: syntax, matchRange: match.range, in: string)\n            \n             Apply attributes\n            textStorage.addAttributes(syntax.syntaxAttributes, range: startSyntaxRange)\n            textStorage.addAttributes(syntax.syntaxAttributes, range: endSyntaxRange)\n            textStorage.addAttributes(syntax.contentAttributes, range: contentRange)\n            \n            if syntax == .codeBlock {\n                applySyntaxHighlighting(in: contentRange)\n            }\n        }\n    }\n    \n    private func calculateRanges(for syntax: MarkdownSyntax, matchRange: NSRange, in string: String) -> (content: NSRange, startSyntax: NSRange, endSyntax: NSRange) {\n        // Your existing range calculation logic here\n        // ...\n    }\n    \n    private func applySyntaxHighlighting(in range: NSRange) {\n         Implement syntax highlighting for code blocks\n         This could involve using a library like Highlight.js or implementing your own syntax highlighting logic\n    }\n}\n```\n\nThis revised version:\n\n1. Caches the regular expressions for better performance.\n2. Separates the range calculation into its own method for better organization.\n3. Adds a placeholder for syntax highlighting in code blocks.\n4. Uses a more structured approach to error handling during regex setup.\n\nThese changes make the code more maintainable, potentially more performant, and easier to extend in the future. The core logic of your original implementation is preserved, but it's organized in a way that's easier to manage and optimize.
        """,
        
        """
        Thank you for providing such a detailed explanation of your situation. You're right that there are several areas where we can optimize your approach. Let's address the issues one by one:\n\n1. FOUC (Flash of Unstyled Content):\nThe main reason for this is likely that you're recreating the entire attributed string on each update. Instead, we should only update the parts that have changed.\n\n2. Performance Optimization:\nWe need to be more selective about when and what we update. Let's use the NSTextStorage methods you mentioned to achieve this.\n\n3. Coordinating between SwiftUI and AppKit:\nWe'll need to ensure that updates from SwiftUI are handled efficiently.\n\nHere's an optimized version of your code:\n\n```swift\nclass MarkdownTextView: NSTextView {\n    private var syntaxList: [MarkdownSyntax] = [.bold, .boldItalic, .italic, .codeBlock, .inlineCode]\n    \n    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {\n        super.init(frame: frameRect, textContainer: container)\n        setupTextStorage()\n    }\n    \n    required init?(coder: NSCoder) {\n        super.init(coder: coder)\n        setupTextStorage()\n    }\n    \n    private func setupTextStorage() {\n        textStorage?.delegate = self\n    }\n    \n    func applyStyles(to range: NSRange) {\n        guard let textStorage = self.textStorage else { return }\n        \n        textStorage.beginEditing()\n        \n        for syntax in syntaxList {\n            styleText(for: syntax, in: range)\n        }\n        \n        textStorage.endEditing()\n    }\n    \n    private func styleText(for syntax: MarkdownSyntax, in range: NSRange) {\n        guard let textStorage = self.textStorage else { return }\n        \n        let string = textStorage.string\n        let searchRange = NSIntersectionRange(range, NSRange(location: 0, length: string.length))\n        \n        let regex = try? NSRegularExpression(pattern: syntax.regex.description, options: [])\n        regex?.enumerateMatches(in: string, options: [], range: searchRange) { match, _, _ in\n            guard let match = match else { return }\n            \n            let matchRange = match.range\n            let contentRange = NSRange(location: matchRange.location + syntax.syntaxCharacters.count,\n                                       length: matchRange.length - 2 * syntax.syntaxCharacters.count)\n            \n            textStorage.addAttributes(syntax.syntaxAttributes, range: NSRange(location: matchRange.location, length: syntax.syntaxCharacters.count))\n            textStorage.addAttributes(syntax.syntaxAttributes, range: NSRange(location: matchRange.location + matchRange.length - syntax.syntaxCharacters.count, length: syntax.syntaxCharacters.count))\n            textStorage.addAttributes(syntax.contentAttributes, range: contentRange)\n        }\n    }\n}\n\nextension MarkdownTextView: NSTextStorageDelegate {\n    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {\n        if editedMask.contains(.editedCharacters) {\n            let extendedRange = NSUnionRange(editedRange, textStorage.editedRange)\n            applyStyles(to: extendedRange)\n        }\n    }\n}\n```\n\nNow, let's go through the changes and how to use this in your NSViewRepresentable:\n\n1. We've made `MarkdownTextView` a subclass of `NSTextView` to encapsulate the styling logic.\n2. We're using `NSTextStorageDelegate` to respond to changes in the text.\n3. The `applyStyles(to:)` method now takes a range parameter, so we only style the changed portion of the text.\n4. We're using `beginEditing()` and `endEditing()` to batch our changes for better performance.\n5. The regex matching is now done using `NSRegularExpression` for better performance.
        """,
        
        """
        Below, I'll provide a **simple** SwiftUI view `setup that demonstrates` how to display chats and messages using `ForEach` and the data fetched from your database. *This example* assumes that you have already set up your data fetching functions as described in the previous steps.

        ### Step 1: Define a ViewModel

        First, let's define a ViewModel that will handle fetching the data and storing it for the view to display:

        ```swift
        import SwiftUI
        import Combine

        class ChatsViewModel: ObservableObject {
            @Dependency(.carerDatabase) var carerDatabase
            @Published var chats = [Chat]()
            @Published var messagesByChatId = [Int64: [Message]]()

            func loadChatsAndMessages(forCarer carerId: Int64) async {
                do {
                    let chats = try await carerDatabase.fetchChatsForCarer(carerId)
                    self.chats = chats
                    for chat in chats {
                        let messages = try await carerDatabase.fetchMessagesForChat(chat.id)
                        messagesByChatId[chat.id] = messages
                    }
                } catch {
                    print("Error fetching chats or messages: ")
                }
            }
        }
        ```

        ### Step 2: Create the SwiftUI View

        Now, let's create a SwiftUI view that uses this ViewModel to display the chats and their corresponding messages:

        ```swift
        struct ChatsView: View {
            @StateObject var viewModel = ChatsViewModel()
            let carerId: Int64  // Assume this is passed to the view

            var body: some View {
                NavigationView {
                    List {
                        ForEach(viewModel.chats, id: \\.id) { chat in
                            Section(header: Text("Chat started on")) {
                                if let messages = viewModel.messagesByChatId[chat.id] {
                                    ForEach(messages, id: \\.id) { message in
                                        Text(message.content)
                                            .padding()
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Chats")
                    .onAppear {
                        Task {
                            await viewModel.loadChatsAndMessages(forCarer: carerId)
                        }
                    }
                }
            }
        }
        ```

        ### Step 3: Integrate the View into Your App

        Now integrate `ChatsView` into your app, making sure to pass a valid `carerId`:

        ```swift
        @main
        struct MyApp: App {
            var body: some Scene {
                WindowGroup {
                    ChatsView(carerId: 1) // Example carer ID
                }
            }
        }
        ```

        ### Explanation

        - **ViewModel (`ChatsViewModel`)**: Responsible for fetching the chats and messages from the database and storing them for the view. It uses the `@Dependency` property wrapper to access the `carerDatabase` directly.
          
        - **View (`ChatsView`)**: Displays a list of chats, each with a section that contains its messages. It uses a `@StateObject` to observe the ViewModel.

        - **Fetching Data**: Data is fetched when the view appears, using the `.onAppear` modifier to trigger an asynchronous task that loads the chats and messages for a given carer.

        This setup provides a clean separation of concerns, with the ViewModel handling data operations and the View focusing solely on presentation. Adjustments can be made based on specific UI/UX requirements, such as adding loading indicators or handling errors more gracefully.
        """,
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
        Using `NSTextView` in your *macOS* app for both input and display of messages can be a viable option, especially if you want to leverage its rich text capabilities and the ability to use attributed strings for advanced styling. Here are some considerations and steps for using `NSTextView` as a read-only component for displaying messages:
        
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
                The text within backticks, including the backticks themselves, is styled with the specified attributes (red color and bold font in this case).
                """,
                """
                Could you explain 'non-greedy’?
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
        "To fix this, you need to preserve the cursor position before updating the text and restore it afterward.",
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
    
    public static let paragraphs: [String] = [
        """
        Could you come up with a function for me, for SwiftUI, that will generate a paragraph or two, with some tweakable parameters for paragprah count, and word count? I dont mind what the words are, they jsut need to look like natural language. Feel free to even supply actual static blocks of strings — actually let’s do that. I will build a library of parapgraphcs, as `[String]`, and can you write me up a function that simply selects one of the paragraphis (i.e. items in the array), and returns it?
        """,
        """
        Using `NSTextView` in your *macOS* app for both input and display of messages can be a viable option, especially if you want to leverage its rich text capabilities and the ability to use attributed strings for advanced styling. Here are some considerations and steps for using `NSTextView` as a read-only component for displaying messages:
        
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
        The text within backticks, including the backticks themselves, is styled with the specified attributes (red color and bold font in this case).
        """,
        """
        Could you explain 'non-greedy’?
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
        
        This modification ensures that the cursor position is saved before the text is updated and then restored to its original position, preventing it from jumping to the end after each character is typed.
        
        This approach assumes that the text changes are not dramatically altering the structure of the text (e.g., inserting or deleting large blocks of text in positions before the cursor), which would require more complex handling of the cursor position. For typical text editing, this should work effectively.
        """,
        "To fix this, you need to preserve the cursor position before updating the text and restore it afterward.",
        """
        Could you start me off by providing code for the following requirement:
        
        I would like to style code within three backticks like ```, followed by a line break, then the body of the code, finally another line break and the last set of three backticks. This is, of course, a typical markdown syntax, to  facilitate the styling of code blocks.
        
        Can you provide a solution for the in the function below?
        """,
        """
        The issue with the cursor jumping to the end of the text in your `StylableTextEditor` appears to be related to how the text is being updated in the `updateNSView` method of your `NSViewRepresentable` implementation. Every time the text changes and you set `textView.string = text`, the cursor position (caret) is reset to the end of the text.
        
        To fix this, you need to preserve the cursor position before updating the text and restore it afterward. Here’s how you can adjust your `updateNSView` method:
        
        This modification ensures that the cursor position is saved before the text is updated and then restored to its original position, preventing it from jumping to the end after each character is typed.
        
        This approach assumes that the text changes are not dramatically altering the structure of the text (e.g., inserting or deleting large blocks of text in positions before the cursor), which would require more complex handling of the cursor position. For typical text editing, this should work effectively.
        """
    ]
    

    
}


