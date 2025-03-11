//
//  Paragraphs+General.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/2/2025.
//

extension TestStrings {
  public static let paragraphs: [String] = [
    """
    Could you come up
    
    with a function for me, for SwiftUI, that will generate a paragraph or two, with some tweakable parameters for paragprah count, and word count? I dont mind what the words are, they jsut need to look like natural language. Feel free to even supply actual static blocks of strings — actually let’s do that. I will build a library of parapgraphcs, as `[String]`, and can you write me up a function that simply selects one of the paragraphis (i.e. items in the array), and returns it?
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
    The text within backticks, including the backticks themselves, is styled with the specified attributes (red color and bold font in this case).
            
    ```
    // This is a brief code comment
    var text: String = "Example text"
    ```
    
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
    """,
    
    """
    I have this list of mock data, for my Swift Conversation app (for chatting with LLMs). I created a few convenient helpers on Date, to make mocking chronological time offsets etc simpler.
    
    I’d like to fashion a ‘realistic’ feeling cadence, to the time offsets in the mock data below, as I think I’ve got usually large time gaps, as it is? And I’d like to use the below helpers, so it’s much more readable. Could you please go through and update my examples, so they make use of this?
    
    ```
    swift
    extension Date {
      public func secondsAgo(_ seconds: TimeInterval) -> Date {
        return Date().addingTimeInterval(-seconds)
      }
      public func minutesAgo(_ minutes: TimeInterval) -> Date {
        return Date().addingTimeInterval(-minutes * 60)
      }
      public func hoursAgo(_ hours: TimeInterval) -> Date {
        return Date().addingTimeInterval(-hours * 3600)
      }
      public func daysAgo(_ days: TimeInterval) -> Date {
        return Date().addingTimeInterval(-days * 86400)
      }
    }
    ```
    """,
    """
    A couple of thoughts. I just realised that this is returning a list of Exchanges; I’m wondering how to approach the next step, as ultimately I suppose I want to display a list of Messages, in the view, you know?
    
    Do I work with a list of Exchanges, and then handle how to display the contents of that, from there? Or do I `.flatMap()` the exchanges into Messages?
    
    Additionally, the nature of the `_sortedExchanges` implementation you suggested was good, however the computed property wasn’t able to mutate that property `_sortedExchanges` from within its getter. I changed it to a mutating func, to try this out, however that resulted in issues in SwiftUI, in the ForEach, where it was saying it cannot be mutating from that vantage point in the ForEach.
    """,
    
    """
    One trait of this type of Conversation, is the concept of Message ‘pairs’, or as I have them in my app, `Exchange`s. Based on the nature of LLM chats *always* following the User Query, Assistant Response format. Even failed Assistant replies will have a present Message, even if it simply reporting the error. Each exchange has 1 `Message<UserRole>`, and 1 `Message<AssistantRole>`.
    
    I am learning about testing, specifically using the new (as of WWDC24) Swift Testing framework. one simple test I want to establish is whether this pairing and sorting is happening correctly. I was wondering; for my SwiftUI view, taking into consideration the various ‘styles’ or methods of handling arrays, collections of data, sorting, filtering etc, what is an efficient method to sort the Messages (and Exchanges) in a Conversation, so they are ordered chronologically (as anyone would expect of a chat app), and do not incur any wasteful array-based operations?
    """,
    
    """
    Here is what the structure should be, for the Macro-generated code:
      - Takes a parameter for one of the properties on `config`
    - Function name is the same as parameter name (e.g. `textColour`)
    - Make a copy of the current `config`
    - Update that copy to have the provided `textColour`
    - Make a copy of the current View struct
    - Update that copy to have the new `config`
    - Return the new view
    
    Usage call site, using SwiftUI’s native `labelStyle()` modifier:
      ```swift
    // Dot-seperated syntax
    Label("Example label text", systemImage: "eye")
      .labelStyle(config.textColour(.green))
    
    // Works with multiple 'chained' declarations 
    Label("More text", systemImage: "document")
      .labelStyle(config.textColour(.orange).lineLimit(2))
    
    // In any order 
    Label("Text example", systemImage: "umbrella")
      .labelStyle(config.lineLimit(1).textColour(.purple))
    ```
    
    Because `config` is of type `CustomLabel`, which conforms to `LabelStyle`, `config` is directly callable from the ‘root’ of the label style modifier, and chainable thanks to it returning mutated copies of itself.
    
    Now, to my main question; I am trying to figure out how to use Swift Syntax to ‘drill down’ into a nested struct (i.e. `LabelConfig`, nested inside `CustomLabel`, which has the Macro attached), so I can extract the properties therein, and use this information to generate the functions I mentioned.
    """,
    
    """
    I am using Point-Free’s `swift-sharing` library, which uses a `withLock` mechanism, to prevent data races etc when mutating a value with the `@Shared` wrapper assigned.
    
    This adds some ceremony, when performing basic assignments. E.g for my type `Preferences`;  `store.preferences.appMode = .note` becomes `$preferences.withLock { $0.appMode = .note }`
    
    I’m attempting to wrap some of this ‘fuss’ into a method that’s a bit nicer to type, at the call site. AppHandler is the parent type for `Preferences`, so `@Shared() var preferences: Preferences`.
    
    If I was to look into a generic constraint, on a single function (rather than a swathe of overloads to ‘catch’ each different type within Preferences, I wonder what I could constrain it to? Could you help me figure this out?
    
    """,
    
    """
    We are working on a Swift Macro, `@Persistable`, whose purpose is to help make custom types just as straightforward to save to user defaults as primitive types like `Int` and `String`. 
    
    - Conform a struct to `Codable` and `RawRepresentable` (if not already present)
    - Generate the base requirements for `RawRepresentable`. E.g. `init?(rawValue: String)`, `var rawValue: String {...}`
    - Generate `CodingKeys` enum, inc. support for providing an `originalName`, for decoding legacy values, via a peer macro e.g. `@Attribute(originalName: "gameTitle") var title: String`
    - Generate `init(from:)`, `func encode(to:)`, inc support for graceful fallbacks where possible via `decodeIfPresent`
    
    """,
    
    """
    I’m now working out a way to also be able to style the equivalent text, in a Swift `AttributedString` context, for display in a SwiftUI Text view. 
    
    I have extended the `MarkdownNode.MarkdownType` type, with regex that I’m doing my best to match to the way SwiftDown parses markdown text (which uses `Down`, which is based on `cmark`).
    
    ```swift
    extension MarkdownNode.MarkdownType {
    public var regexLiteral: Regex<(Substring, Substring, Substring, Substring)>? {
    switch self {
      case .quote: /???/
      case .list: /???/
      case .code: /(`)((?:[^`\n])+?)(`)/
    ```
    
    Here I have an in-progress function that tries to ‘recreate’ the matching/styling process, using the *same* theme (`styled(theme: MarkdownTheme)`) as is applied to the actual SwiftDown Editor. The idea being that I could have a static (non-editable) SwiftUI Text view, and the `SwiftDownEditor`, both with the same theme applied, and my implementation smoothing out the obvious differences between these domains, in the middle.
    
    This is actually all working (in the sense that my rough early sketch does indeed highlight Markdown inline code grammar with the `.highlight` style.
                                  
    So now I’m just trying to work out how to hook up my existing logic in the ‘guts’ of SwiftDown, where I’ve been working, and replicate this effectively but for the above `AttributedString`-centric application.
    
    This is just a snippet from part of the SwiftDown implementation internals.
    ```swift
    mutating private func configsureStyles(_ theme: MarkdownTheme) {
      
      for mdType in MarkdownNode.MarkdownType.allCases {
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        /// Add colors
        attributes[.foregroundColor] = theme.colors[mdType]
        
        /// Add fonts, if available
        if let font = theme.fonts.fonts[mdType]?.resolvedFont() {
          attributes[.font] = font
          
        } else {
          /// Use default font for this markdown type
          attributes[.font] = mdType.defaultFont().resolvedFont()
        }
        
        styles[mdType] = Style(attributes: attributes)
      }
    }
    
    ```
    """,
    
    """
    I want to also set weight in the same convenient way — but I noticed a possible gotcha? Will I need to ‘drill down’ *another* level here (a bit like how we’ve been doing with `MarkdownTheme.set() > MarkdownTheme.Fonts.with() > FontConfig.setSize()`).
    
    """,
    
    """
    I could create a few presets, of existing fonts? That I know are compiled / set up correctly etc? And then provide a progressive mechanism to still allow the user to define an unknown font name? I’m not sure, let me know what you think.
    
    Ideally, the user could ‘say’; I want this font (e.g. Comic Sans), with this weight (medium), or style (italics), or design (monospaced vs normal), with size (CGFloat), and it would all emerge working just fine.
    
    ```swift
    public struct MarkdownTheme {
      public var colors: ThemeColors = .defaults
      public var fonts: ThemeFonts = ThemeFonts()
      public var editor: EditorStyles = .defaults
    }
    
    public typealias MarkdownColorMap = [MarkdownNode.MarkdownType: NSColor]
    public typealias MarkdownFontMap = [MarkdownNode.MarkdownType: FontConfig]
    
    
    public struct FontConfig {
      var style: NSFont
      var traits: NSFontDescriptor.SymbolicTraits
      var size: CGFloat
      
      init(size: CGFloat, traits: NSFontDescriptor.SymbolicTraits) {
        
      }
      
      static let body = FontConfig(
        style: .systemFont(ofSize: size),
        traits: traits,
        size: size
      )
      
    }
    
    ```
    
    ---
    
    ## Response (Deep Seek)
    
    To create an ergonomic and type-safe API for defining fonts in your Swift Package, you can use a combination of enums and structs to encapsulate font configurations. Here's a step-by-step solution:
      
      ### 1. Define a `FontDescriptor` Enum
    This enum represents the type of font (system or custom) along with its parameters.
    
    ```swift
    public enum FontDescriptor {
    case system(weight: NSFont.Weight, design: NSFontDescriptor.SystemDesign)
    case named(String)
    }
    ```
    
    ### 2. Create a `FontConfig` Struct
    This struct holds the font descriptor, symbolic traits, size, and methods to resolve the font.
    
    """,
    
    """
    Some thoughts / requirements:
    
    a) How to expose the exact cases of the `MarkdownNode.MarkdownType` enum to the user of the package (so, another developer — not considering the end-user of any resulting app itself just now), allowing them to define colours and other properties on a per case basis
    
    b) Also abstract away as much fuss / non-pertinent detail as possible
    
    c) Allow this theme to update SwiftDown at runtime, would be ideal (this would concern the end-user, who may wish to select a theme from a dropdown etc.
    
    """,
    
    """
    I’m having a total mind blank, and struggling (in Swift) to switch over a CaseIterable enum! This follows on from my first question. The context is a Markdown editor using `NSTextView`.
    
    Possible values for `color` are:
    
    `color: AnyObject = "h2"`
    `color: AnyObject = "body"`
    `color: AnyObject = "blockQuote"`
    `color: AnyObject = "inlineCode"`
    
    """,
    
  ]
}
