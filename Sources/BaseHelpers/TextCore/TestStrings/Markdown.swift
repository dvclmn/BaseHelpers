//
//  File.swift
//
//
//  Created by Dave Coleman on 16/6/2024.
//

import Foundation

public extension TestStrings {
  
  struct Markdown {
    
    public static let codeBlocks: String = """
    
    Some Swift code:
    
    ```swift
    import Shortcuts
    import BaseHelpers
    
    struct MessageInputView: View {
    
    @Environment(\\.store) private var store
    
    @State private var metrics: String = ""
    @State private var isManualMode: Bool = false
    
    //  @State private var editorHeight: CGFloat = .zero
    
    @Bindable var conversationStore: StoreOf<SingleShrimConversation>
    
    let syntaxButtons: [Markdown.Syntax] = [.bold, .italic, .inlineCode]
    
    @FocusState var focused: Focus.State.Element?
    
    //  @Bindable var conversation: StoreOf<SingleChumeConversation>
    
    var body: some View {
    
    @Bindable var focus = store.scope(state: \\.focus, action: \\.focus)
    @Bindable var preferences: StoreOf<Preferences> = store.scope(state: \\.preferences, action: \\.preferences)
    ```
    """
    
    static let twoInlineCode: String = """
    This brief `inline code`, with text contents, lines `advance expanding` the view in the current writing direction.
    
    It does have more than two paragraphs, which I'm hoping will help me to verify that the code is able to count elements of a particular kind of markdown syntax, not just fragments or paragraphs.
    
    We'll have to just see if it works.
    
    Thank you for sharing your code and explaining your setup. It's great to see you're working on a markdown parsing and styling system using TextKit 2. Let's address your questions and then discuss some ideas for your implementation.
    
    Invalidating Attributes:
    
    When you call invalidateAttributes(in: NSRange) on a text storage, you're essentially telling the text system that the attributes in the specified range may have changed and need to be recalculated. This doesn't `remove` or modify the attributes directly; instead, it triggers the text system to update its internal caches and redraw the affected text. This is useful when you've made `changes` to the text or its `attributes and want` to ensure that the display is updated correctly.
    
    Regarding your markdown parsing and styling setup:
    
    Your approach of separating the parsing (which is more expensive) and the styling (which should be more nimble) is a good strategy. Here are some ideas and suggestions to potentially improve `your implementation`.
    """
    
    static let shortSample: String = """
  This *brief* block quote, with ==text contents==, lines `advance 
  expanding` the view in the current writing direction.ExampleView".
  
  Includes one line break.
  
  Followed by another. In addition, here is a list:
  
  - [AttributeContainer](http://apple.com) is a container for attributes.
  - By configuring the container, we can set, replace, and merge
  - A large number of attributes for a string (or fragment) at once.
  """
    
    static let exampleMarkdown: String = """
    # Markdown samples
    ## Overview of the sample
    
    ```swift
    @State private var selectionInfo: EditorInfo.Selection? = nil
    // @State private var editorHeight: CGFloat = .zero
    ```
    # This is also a heading
    With other stuff below
    
    Usually, `NSTextView` manages the *layout* process inside **the viewport** interacting ~~with its delegate~~.
    
    - [AttributeContainer](http://apple.com) is a container for attributes.
    - By configuring the container, we can set, replace, and merge
    - A large number of attributes for a string (or fragment) at once.
    
    ```python
    // There is also some basic code
    var x = y
    ```
    
    ### Markdown syntax summary
    A `viewport` is a _rectangular_ area within a ==flipped coordinate system== expanding along the y-axis, with __bold alternate__, as well as ***bold italic*** emphasis.
    
    1. You’d mentioned this is rendered within an OpenGL window
    2. Despite the implementation details under the hood
    3. They can only speculate, but perhaps OpenGL here is useful
    
    > This *brief* block quote, with ==text contents==, lines `advance expanding` the view in the current writing direction.ExampleView
    
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
    
    Now, let's create a SwiftUI view that uses this ViewModel to display the chats and their corresponding messages.
    
    1. You’d mentioned this is rendered within an OpenGL window
    2. Despite the implementation details under the hood
    3. They can only speculate, but perhaps OpenGL here is useful
    
    > This *brief* block quote, with ==text contents==, lines `advance expanding` the view in the current writing direction.ExampleView
    
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
    
    Now, let's create a SwiftUI view that uses this ViewModel to display the chats and their corresponding messages.
    
    """
    
    public static let anotherMarkdownString: String = """
  # This is the beginning of a really long heading so i can see what it does
  ## First, a message
  ### And a third, a header that's small
  I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.
  
  ```
  func updateNSView(_ nsView: NSTextView, context: Context) {
      nsView.textStorage?.setAttributedString(text)
  }
  ```
  
  As well as some text down here.
  
  And some here just in case
  """
    
    
    public static let shortMarkdownBasics: String = """
        # Markdown samples
        ## Overview of the sample
        Usually, `NSTextView` manages the *layout* process inside **the viewport** interacting ~~with its delegate~~.
        
        - [AttributeContainer](http://apple.com) is a container for attributes.
        - By configuring the container, we can set, replace, and merge
        - A large number of attributes for a string (or fragment) at once.
        
        ### Markdown syntax summary
        
        A `viewport` is a _rectangular_ area within a ==flipped coordinate system== expanding along the y-axis, with __bold alternate__, as well as ***bold italic*** emphasis, which has a alt version with ___three underscores___ like that.
        
        1. You’d mentioned this is rendered within an OpenGL window
        2. Despite the implementation details under the hood
        3. They can only speculate, but perhaps OpenGL here is useful
        
        ```python
        // There is also some basic code
        var x = y
        ```
        
        > This *brief* block quote, with ==text contents==, lines `advance expanding` the view in the current writing direction.ExampleView
        """
    
    public static let basicMarkdown: String = """
        # This is the beginning of a **really long** heading so i can see what it does
        ## Second heading
        ### Third heading yay
        
        I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and ==highlights== it? Also, we need some ***extra emphasis*** on this text.
        
        ```swift
        let highlightr = Highlightr()
        let backticks = "```"
        highlightr?.setTheme(to: "xcode-dark-butts")
        ```
        
         - I `think this is something` worth thinking about in the context of all tooling we use. 
        - If I do my job correctly with the IDE, you shouldn't be thinking about much outside of the program you're writing. 
        
        ***
        
        - The goal is to keep you focused, so you never have to stop and reach for the documentation of the IDE, or Zig itself. Based on what you're doing

        - [x] Finish my changes
        - [ ] Push my commits to GitHub
        - [ ] Open a pull request
        - [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
        - [x] list syntax required (any unordered or ordered list supported)
        - [ ] this is a complete item
        - [ ] this is an incomplete item
        
        1. First, calculate the available width:
        
         ```swift
         let availableWidth = self.windowSize.size.width - AppHandler.windowSizeBuffer
         ```
        
        2. Define helper properties for panel widths:
        
        ```swift
        var sidebarWidth: Double {
        sidebar.isEnabled ? sidebar.width : 0
        }
        
        var inspectorWidth: Double {
        inspector.isEnabled ? inspector.width : 0
        }
        ```
        
        3. Calculate if there's room for content and each panel:
        
        ```swift
        let roomForContent = availableWidth >= AppHandler.contentMinWidth
        let roomForSidebar = availableWidth >= (AppHandler.contentMinWidth + sidebarWidth)
        let roomForInspector = availableWidth >= (AppHandler.contentMinWidth + inspectorWidth)
        let roomForBoth = availableWidth >= (AppHandler.contentMinWidth + sidebarWidth + inspectorWidth)
        ```
        
        I think this is something worth thinking about in the context of all tooling we use. If I do my job correctly with the IDE, you shouldn't be thinking about much outside of the program you're writing. The goal is to keep you focused, so you never have to stop and reach for the documentation of the IDE, or Zig itself. Based on what you're doing, all information should be right in front of you, or a click/hotkey away if it is too intrusive to display inline. Little sidequests to find what arguments a function takes, lookup a hotkey, etc., should be kept to a minimum. I'll be keeping this in mind as I work on the IDE.
        
        ## And then this heading
        And some more words here. If you would like to contribute to the development of Highlightr, please follow the guidelines outlined in the CONTRIBUTING.md file in the GitHub repository.
        
        ```swift
        # Python program to find the sum of natural using recursive function
        
        def recur_sum(n):
           if n <= 1:
               return n
           else:
               return n + recur_sum(n-1)
        
        # change this value for a different result
        num = 16
        
        if num < 0:
           print("Enter a positive number")
        else:
           print("The sum is",recur_sum(num))
        ```
        
        As well as some text down here.
        
        And some here just in case
        
        ```
        func updateNSView(_ nsView: NSTextView, context: Context) {
            nsView.textStorage?.setAttributedString(text)
        }
        ```
        
        # This is the beginning of a really long heading so i can see what it does
        ## First, a message
        ### And a third, a header that's small
        
        
        
        I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.
        
        
        
        As well as some text down here.
        
        And some here just in case
        I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.
        
        ```
        func updateNSView(_ nsView: NSTextView, context: Context) {
            nsView.textStorage?.setAttributedString(text)
        }
        ```
        
        As well as some text down here.
        
        And some here just in case
        
        I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.
        """
    
    
    
    public static let bigText = """
    
    Links: [Hello](https://www.google.com)
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    # Headers
    
    ```
    # h1 Heading 8-)
    ## h2 Heading
    ### h3 Heading
    #### h4 Heading
    ##### h5 Heading
    ###### h6 Heading
    
    Alternatively, for H1 and H2, an underline-ish style:
    
    Alt-H1
    ======
    
    Alt-H2
    ------
    ```
    
    # h1 Heading 8-)
    ## h2 Heading
    ### h3 Heading
    #### h4 Heading
    ##### h5 Heading
    ###### h6 Heading
    
    Alternatively, for H1 and H2, an underline-ish style:
    
    Alt-H1
    ======
    
    Alt-H2
    ------
    
    ------
    
    # Emphasis
    
    ```
    Emphasis, aka italics, with *asterisks* or _underscores_.
    
    Strong emphasis, aka bold, with **asterisks** or __underscores__.
    
    Combined emphasis with **asterisks and _underscores_**.
    
    Strikethrough uses two tildes. ~~Scratch this.~~
    
    **This is bold text**
    
    __This is bold text__
    
    *This is italic text*
    
    _This is italic text_
    
    ~~Strikethrough~~
    ```
    
    Emphasis, aka italics, with *asterisks* or _underscores_.
    
    Strong emphasis, aka bold, with **asterisks** or __underscores__.
    
    Combined emphasis with **asterisks and _underscores_**.
    
    Strikethrough uses two tildes. ~~Scratch this.~~
    
    **This is bold text**
    
    __This is bold text__
    
    *This is italic text*
    
    _This is italic text_
    
    ~~Strikethrough~~
    
    ------
    
    # Lists
    
    ```
    1. First ordered list item
    2. Another item
    ⋅⋅* Unordered sub-list.
    1. Actual numbers don't matter, just that it's a number
    ⋅⋅1. Ordered sub-list
    4. And another item.
    
    ⋅⋅⋅You can have properly indented paragraphs within list items. Notice the blank line above, and the leading spaces (at least one, but we'll use three here to also align the raw Markdown).
    
    ⋅⋅⋅To have a line break without a paragraph, you will need to use two trailing spaces.⋅⋅
    ⋅⋅⋅Note that this line is separate, but within the same paragraph.⋅⋅
    ⋅⋅⋅(This is contrary to the typical GFM line break behaviour, where trailing spaces are not required.)
    
    * Unordered list can use asterisks
    - Or minuses
    + Or pluses
    
    1. Make my changes
        1. Fix bug
        2. Improve formatting
            - Make the headings bigger
    2. Push my commits to GitHub
    3. Open a pull request
        * Describe my changes
        * Mention all the members of my team
            * Ask for feedback
    
    + Create a list by starting a line with `+`, `-`, or `*`
    + Sub-lists are made by indenting 2 spaces:
      - Marker character change forces new list start:
        * Ac tristique libero volutpat at
        + Facilisis in pretium nisl aliquet
        - Nulla volutpat aliquam velit
    + Very easy!
    ```
    
    1. First ordered list item
    2. Another item
    ⋅⋅* Unordered sub-list.
    1. Actual numbers don't matter, just that it's a number
    ⋅⋅1. Ordered sub-list
    4. And another item.
    
    ⋅⋅⋅You can have properly indented paragraphs within list items. Notice the blank line above, and the leading spaces (at least one, but we'll use three here to also align the raw Markdown).
    
    ⋅⋅⋅To have a line break without a paragraph, you will need to use two trailing spaces.⋅⋅
    ⋅⋅⋅Note that this line is separate, but within the same paragraph.⋅⋅
    ⋅⋅⋅(This is contrary to the typical GFM line break behaviour, where trailing spaces are not required.)
    
    * Unordered list can use asterisks
    - Or minuses
    + Or pluses
    
    1. Make my changes
        1. Fix bug
        2. Improve formatting
            - Make the headings bigger
    2. Push my commits to GitHub
    3. Open a pull request
        * Describe my changes
        * Mention all the members of my team
            * Ask for feedback
    
    + Create a list by starting a line with `+`, `-`, or `*`
    + Sub-lists are made by indenting 2 spaces:
      - Marker character change forces new list start:
        * Ac tristique libero volutpat at
        + Facilisis in pretium nisl aliquet
        - Nulla volutpat aliquam velit
    + Very easy!
    
    ------
    
    # Task lists
    
    ```
    - [x] Finish my changes
    - [ ] Push my commits to GitHub
    - [ ] Open a pull request
    - [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
    - [x] list syntax required (any unordered or ordered list supported)
    - [x] this is a complete item
    - [ ] this is an incomplete item
    ```
    
    - [x] Finish my changes
    - [ ] Push my commits to GitHub
    - [ ] Open a pull request
    - [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
    - [x] list syntax required (any unordered or ordered list supported)
    - [ ] this is a complete item
    - [ ] this is an incomplete item
    
    ------
    
    # Ignoring Markdown formatting
    
    You can tell GitHub to ignore (or escape) Markdown formatting by using \\ before the Markdown character.
    
    ```
    Let's rename \\*our-new-project\\* to \\*our-old-project\\*.
    ```
    
    Let's rename \\*our-new-project\\* to \\*our-old-project\\*.
    
    ------
    
    # Links
    
    ```
    [I'm an inline-style link](https://www.google.com)
    
    [I'm an inline-style link with title](https://www.google.com "Google's Homepage")
    
    [I'm a reference-style link][Arbitrary case-insensitive reference text]
    
    [I'm a relative reference to a repository file](../blob/master/LICENSE)
    
    [You can use numbers for reference-style link definitions][1]
    
    Or leave it empty and use the [link text itself].
    
    URLs and URLs in angle brackets will automatically get turned into links.
    http://www.example.com or <http://www.example.com> and sometimes
    example.com (but not on Github, for example).
    
    Some text to show that the reference links can follow later.
    
    [arbitrary case-insensitive reference text]: https://www.mozilla.org
    [1]: http://slashdot.org
    [link text itself]: http://www.reddit.com
    ```
    
    [I'm an inline-style link](https://www.google.com)
    
    [I'm an inline-style link with title](https://www.google.com "Google's Homepage")
    
    [I'm a reference-style link][Arbitrary case-insensitive reference text]
    
    [I'm a relative reference to a repository file](../blob/master/LICENSE)
    
    [You can use numbers for reference-style link definitions][1]
    
    Or leave it empty and use the [link text itself].
    
    URLs and URLs in angle brackets will automatically get turned into links.
    http://www.example.com or <http://www.example.com> and sometimes
    example.com (but not on Github, for example).
    
    Some text to show that the reference links can follow later.
    
    [arbitrary case-insensitive reference text]: https://www.mozilla.org
    [1]: http://slashdot.org
    [link text itself]: http://www.reddit.com
    
    ------
    
    # Images
    
    ```
    Here's our logo (hover to see the title text):
    
    Inline-style:
    ![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
    
    Reference-style:
    ![alt text][logo]
    
    [logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
    
    ![Minion](https://octodex.github.com/images/minion.png)
    ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")
    
    Like links, Images also have a footnote style syntax
    
    ![Alt text][id]
    
    With a reference later in the document defining the URL location:
    
    [id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"
    ```
    
    Here's our logo (hover to see the title text):
    
    Inline-style:
    ![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
    
    Reference-style:
    ![alt text][logo]
    
    [logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
    
    ![Minion](https://octodex.github.com/images/minion.png)
    ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")
    
    Like links, Images also have a footnote style syntax
    
    ![Alt text][id]
    
    With a reference later in the document defining the URL location:
    
    [id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"
    
    ------
    
    # [Footnotes](https://github.com/markdown-it/markdown-it-footnote)
    
    ```
    Footnote 1 link[^first].
    
    Footnote 2 link[^second].
    
    Inline footnote^[Text of inline footnote] definition.
    
    Duplicated footnote reference[^second].
    
    [^first]: Footnote **can have markup**
    
        and multiple paragraphs.
    
    [^second]: Footnote text.
    ```
    
    Footnote 1 link[^first].
    
    Footnote 2 link[^second].
    
    Inline footnote^[Text of inline footnote] definition.
    
    Duplicated footnote reference[^second].
    
    [^first]: Footnote **can have markup**
    
        and multiple paragraphs.
    
    [^second]: Footnote text.
    
    ------
    
    # Code and Syntax Highlighting
    
    ```
    Inline `code` has `back-ticks around` it.
    ```
    
    Inline `code` has `back-ticks around` it.
    
    ```c#
    using System.IO.Compression;
    
    #pragma warning disable 414, 3021
    
    namespace MyApplication
    {
        [Obsolete("...")]
        class Program : IInterface
        {
            public static List<int> JustDoIt(int count)
            {
                Console.WriteLine($"Hello {Name}!");
                return new List<int>(new int[] { 1, 2, 3 })
            }
        }
    }
    ```
    
    ```css
    @font-face {
      font-family: Chunkfive; src: url('Chunkfive.otf');
    }
    
    body, .usertext {
      color: #F0F0F0; background: #600;
      font-family: Chunkfive, sans;
    }
    
    @import url(print.css);
    @media print {
      a[href^=http]::after {
        content: attr(href)
      }
    }
    ```
    
    ```javascript
    function $initHighlight(block, cls) {
      try {
        if (cls.search(/\\bno\\-highlight\\b/) != -1)
          return process(block, true, 0x0F) +
                 ` class="${cls}"`;
      } catch (e) {
        /* handle exception */
      }
      for (var i = 0 / 2; i < classes.length; i++) {
        if (checkCondition(classes[i]) === undefined)
          console.log('undefined');
      }
    }
    
    export  $initHighlight;
    ```
    
    ```php
    require_once 'Zend/Uri/Http.php';
    
    namespace Location\\Web;
    
    interface Factory
    {
        static function _factory();
    }
    
    abstract class URI extends BaseURI implements Factory
    {
        abstract function test();
    
        public static $st1 = 1;
        const ME = "Yo";
        var $list = NULL;
        private $var;
    
        /**
         * Returns a URI
         *
         * @return URI
         */
        static public function _factory($stats = array(), $uri = 'http')
        {
            echo __METHOD__;
            $uri = explode(':', $uri, 0b10);
            $schemeSpecific = isset($uri[1]) ? $uri[1] : '';
            $desc = 'Multi
    line description';
    
            // Security check
            if (!ctype_alnum($scheme)) {
                throw new Zend_Uri_Exception('Illegal scheme');
            }
    
            $this->var = 0 - self::$st;
            $this->list = list(Array("1"=> 2, 2=>self::ME, 3 => \\Location\\Web\\URI::class));
    
            return [
                'uri'   => $uri,
                'value' => null,
            ];
        }
    }
    
    echo URI::ME . URI::$st1;
    
    __halt_compiler () ; datahere
    datahere
    datahere */
    datahere
    ```
    
    ------
    
    # Tables
    
    ```
    Colons can be used to align columns.
    
    | Tables        | Are           | Cool  |
    | ------------- |:-------------:| -----:|
    | col 3 is      | right-aligned | $1600 |
    | col 2 is      | centered      |   $12 |
    | zebra stripes | are neat      |    $1 |
    
    There must be at least 3 dashes separating each header cell.
    The outer pipes (|) are optional, and you don't need to make the
    raw Markdown line up prettily. You can also use inline Markdown.
    
    Markdown | Less | Pretty
    --- | --- | ---
    *Still* | `renders` | **nicely**
    1 | 2 | 3
    
    | First Header  | Second Header |
    | ------------- | ------------- |
    | Content Cell  | Content Cell  |
    | Content Cell  | Content Cell  |
    
    | Command | Description |
    | --- | --- |
    | git status | List all new or modified files |
    | git diff | Show file differences that haven't been staged |
    
    | Command | Description |
    | --- | --- |
    | `git status` | List all *new or modified* files |
    | `git diff` | Show file differences that **haven't been** staged |
    
    | Left-aligned | Center-aligned | Right-aligned |
    | :---         |     :---:      |          ---: |
    | git status   | git status     | git status    |
    | git diff     | git diff       | git diff      |
    
    | Name     | Character |
    | ---      | ---       |
    | Backtick | `         |
    | Pipe     | \\|        |
    ```
    
    Colons can be used to align columns.
    
    | Tables        | Are           | Cool  |
    | ------------- |:-------------:| -----:|
    | col 3 is      | right-aligned | $1600 |
    | col 2 is      | centered      |   $12 |
    | zebra stripes | are neat      |    $1 |
    
    There must be at least 3 dashes separating each header cell.
    The outer pipes (|) are optional, and you don't need to make the
    raw Markdown line up prettily. You can also use inline Markdown.
    
    Markdown | Less | Pretty
    --- | --- | ---
    *Still* | `renders` | **nicely**
    1 | 2 | 3
    
    | First Header  | Second Header |
    | ------------- | ------------- |
    | Content Cell  | Content Cell  |
    | Content Cell  | Content Cell  |
    
    | Command | Description |
    | --- | --- |
    | git status | List all new or modified files |
    | git diff | Show file differences that haven't been staged |
    
    | Command | Description |
    | --- | --- |
    | `git status` | List all *new or modified* files |
    | `git diff` | Show file differences that **haven't been** staged |
    
    | Left-aligned | Center-aligned | Right-aligned |
    | :---         |     :---:      |          ---: |
    | git status   | git status     | git status    |
    | git diff     | git diff       | git diff      |
    
    | Name     | Character |
    | ---      | ---       |
    | Backtick | `         |
    | Pipe     | \\|        |
    
    ------
    
    # Blockquotes
    
    ```
    > Blockquotes are very handy in email to emulate reply text.
    > This line is part of the same quote.
    
    Quote break.
    
    > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote.
    
    > Blockquotes can also be nested...
    >> ...by using additional greater-than signs right next to each other...
    > > > ...or with spaces between arrows.
    ```
    
    > Blockquotes are very handy in email to emulate reply text.
    > This line is part of the same quote.
    
    Quote break.
    
    > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote.
    
    > Blockquotes can also be nested...
    >> ...by using additional greater-than signs right next to each other...
    > > > ...or with spaces between arrows.
    
    ------
    
    # Inline HTML
    
    ```
    <dl>
      <dt>Definition list</dt>
      <dd>Is something people use sometimes.</dd>
    
      <dt>Markdown in HTML</dt>
      <dd>Does *not* work **very** well. Use HTML <em>tags</em>.</dd>
    </dl>
    ```
    
    <dl>
      <dt>Definition list</dt>
      <dd>Is something people use sometimes.</dd>
    
      <dt>Markdown in HTML</dt>
      <dd>Does *not* work **very** well. Use HTML <em>tags</em>.</dd>
    </dl>
    
    ------
    
    # Horizontal Rules
    
    ```
    Three or more...
    
    ---
    
    Hyphens
    
    ***
    
    Asterisks
    
    ___
    
    Underscores
    ```
    
    Three or more...
    
    ---
    
    Hyphens
    
    ***
    
    Asterisks
    
    ___
    
    Underscores
    
    ------
    
    # YouTube Videos
    
    ```
    <a href="http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE" target="_blank">
    <img src="http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg" alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10">
    </a>
    ```
    
    <a href="http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE" target="_blank">
    <img src="http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg" alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10">
    </a>
    
    ```
    [![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](http://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID_HERE)
    ```
    
    [![IMAGE ALT TEXT HERE](https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/YouTube_logo_2015.svg/1200px-YouTube_logo_2015.svg.png)](https://www.youtube.com/watch?v=ciawICBvQoE)
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    @Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \\"\\(Wow cat dog)\\"
    
    Links: [Hello](https://www.google.com)
    
    ```Swift
    
    
    let grammar = Grammar(scopeName: "source.example")
    ```
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \\"\\(Wow cat dog)\\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \\"\\(Wow cat dog)\\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \\"\\(Wow cat dog)\\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \\"\\(Wow cat dog)\\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    
    # My Heading
    ## Heading 2
    ### Heading 3
    
    Keywords are dog, Dog, cat and Cat
    
    You're allowed strings: "It's raining cats and dogs"
    And string interpolation: \"\\(Wow cat dog)\"
    
    Links: [Hello](https://www.google.com)
    
    Testing out // comments
    
    This shouldn't be commented
    
    /*
     * TODO: Woo comment block
     */
    
    _Italic_ *Bold* _Italic and *bold*_ *Bold and _italic_*
    
    Emojis are allowed 😊
    """
    
    public static let massiveMarkdown: String = """
      # Massive markdown text sample

    # Getting view size in SwiftUI without GeometryReader
    Published: Nov. 26, 2024  [Level up your Swift! 📚 With this selection of books that will teach you Swift, SwiftUI, UIKit, SpriteKit, Advanced iOS and much more by Hacking With Swift!   See books](https://gumroad.com/a/454169715)   

    Recently I needed to know size of SwiftUI container to layout horizontal carousel. The reason was to have one items always at least a tiny bit visible so users can reliably find the rest by scrolling. I started with GeometryReader and quickly got frustrated and started looking for another solution…

    There are many problems with GeometryReader and its behavior, which is why I am trying to avoid it whenever I can.

    Anyway… I started looking for alternative sort of expecting to find nothing or perhaps something for iOS 18, but I need to support iOS 16+. However I did discover modifier `onGeometryChanged`.

    **This is actually new with iOS 18 (Xcode 16) but it has been backported all the way to iOS 16.** It will tell you when the frame or size of your view changes. Which means you can use this in `@State` and update child views accordingly.

    The new modifier also makes it easy to create layout loops, so be careful. If I wanted to modify size of the view that has its geometry tracked, that would again invoke the geometry changed and so on.

    The `onGeometryChanged` approach also seems to work well for “sized to content bottom sheets”. Below is super simple example but it should show all the relevant parts.

    You need property to hold the height and then these modifiers:

    ```
    SheetContentView() .onGeometryChange(for: CGSize.self) { proxy in proxy.size } action: { self.contentHeight = $0.height // Alternatively you can get the `width` here } .presentationDetents([.height(contentHeight)])
    ```

    Here is entire code you can copy and run:

    ```
    import SwiftUI struct ContentView: View { @State private var contentHeight: CGFloat = 0 @State private var showsSheet = false @State private var fontSize: CGFloat = 50 var body: some View { VStack(spacing: 20) { Text("onGeometryChange example") .font(.largeTitle) .multilineTextAlignment(.center) Button { fontSize = CGFloat.random(in: 30...80) showsSheet = true } label: { Text("Show sheet") } .buttonStyle(.bordered) } .padding() .sheet(isPresented: $showsSheet) { VStack { Text("As you can see this sheet is dynamically sized to fit this content.") .fixedSize(horizontal: false, vertical: true) .padding() .font(.system(size: fontSize)) } .onGeometryChange(for: CGSize.self) { proxy in proxy.size } action: { self.contentHeight = $0.height // Alternatively you can get the `width` here } .presentationDetents([.height(contentHeight)]) } }
    }
    ```

    Just a few snippets to reference later when using Kingfisher library.

     [Swift & iOS](https://nemecek.be/blog/swift-and-ios)  

    Careful how you name your attributes...

     [Swift & iOS](https://nemecek.be/blog/swift-and-ios)  


    Thanks for this.

    I am doing the process here in my subclassed `NSTextStorage`. Could you help me kinda wire this up, based on where you mentioned ` return self.processMarkdown(inputText)`?

    ```swift
    class MarkdownTextStorage: NSTextStorage {

      private let backingStore = NSMutableAttributedString()
      private let highlightr = Highlightr()
      private let codeStorage = CodeAttributedString()

      let configuration: EditorConfiguration
    // inits...
      override var string: String {
        backingStore.string
      }

      override func attributes(
        at location: Int, effectiveRange range: NSRangePointer?
      ) -> [NSAttributedString.Key: Any] {
        backingStore.attributes(at: location, effectiveRange: range)
      }

      override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
        endEditing()
      }

      override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
      }

      override func processEditing() {
        super.processEditing()
        applyDefaultAttributes()
        applyMarkdownStyles()
        highlightCodeBlocks()
      }

      private func applyDefaultAttributes() {
        let range = NSRange(location: 0, length: backingStore.length)
        backingStore.setAttributes(configuration.defaultTypingAttributes, range: range)
      }

      private func applyMarkdownStyles() {
        for syntax in Markdown.Syntax.allCases {
          styleSyntaxType(syntax: syntax)
        }
      }

    ```



    Marking views to be rendered with colors, handling images and more.

     [Swift & iOS](https://nemecek.be/blog/swift-and-ios)  

    Quite a lot higher trial start rate with lower conversion percentage.

     [Swift & iOS](https://nemecek.be/blog/swift-and-ios)  

    SwiftUI

    My “glow” animation started going wrong when switching tabs in a tab bar.

     [Swift & iOS](https://nemecek.be/blog/swift-and-ios)  

    Short blog post about supporting StandBy mode introduced in iOS 17.

     [Swift & iOS](https://nemecek.be/blog/swift-and-ios)  

    [Getting view size in SwiftUI without GeometryReader](https://nemecek.be/blog/208/getting-view-size-in-swiftui-without-geometryreader)

    ```
    "**??bo. ,' '*?8b. ,d8b ?8b ,d8888 " ASCII art "?b. d88887 is no less 'b 88888 than one more 8 88888 ARTform " 8 88888 :8 d88888bo,._ js _,.od888b:8b 8Y888888888b d88P88888P:88 8:888' Y8P88 Y7" Y8P' :78 8j887 88 ::. :8 YY88: ;88 '':.. dP :!88b ,d8P :8; 888b,d88P' ;8 Y8888888Ln,__,n. d8 :8888888888888888b ,88P Y8888888888888888b d88; :888888P"''''''Y88b,d88P "Y888888888888888888P" "Y88888888888888P" js '"*?88888?*"'
    ```

    For some reason, people tend to think ASCII art requires an insane amount of talent or patience. Many associate it with boredom rather than artistic expression. I've heard about "the old times of ASCII art", even though this artform is far from dying.

    It's too hard to get rid of such misconceptions through simple words. You won't know what ASCII art is like until you try, and then you will discover that **it's no less than one more artform**. It's performed by people like you and me, with lifes, schedules, and, above all, skills of their own.

    This tutorial will show you some methods to draw ASCII art, focusing in "[solid style ASCII](https://www.roysac.com/tutorial/asciiarttutorial.html#asc1a)". I hope to make it easier for you to find your personal style, subjects and your way through the unlimited possibilities of ASCII. And this tutorial doesn't target only wannabe ASCII artists. By showing my way to ASCII, I also want the general public to understand how easy and fun it can be. Well, enough of my speech, let's make ASCII art!

    **Julio Sepia**
    ASCII artist since 2005
    #### 1a. What is solid ASCII?

    ```
    ,od8888bn.      ,.od88bo,
    d8P┤   `*88bn. ,       `Y8b
    88┤      `*888b.        `D8
    Y8b        ,`*Y8bn.    ,d8P
    `*Y8bn,. À     `*+88888P*┤

      Infinity             js
    ```

    Solid is a common style in ASCII art, where the pictures are composed of filled, consistant shapes. The "infinity" symbol represented here is an example of solid ASCII art. Solid pictures are flat and thick. There is no shading involved, and there are rarely any thin lines.

    In solid style, there's usually an unique character to **fill** the larger areas (a **filler**), and complementary characters on the edges to create the [anti-aliasing](https://www.roysac.com/tutorial/asciiarttutorial.html#asc3b). Solid style ASCII doesn't suit well for small, detailed pictures, but it's perfect for logos, large silhouettes and highly contrasted pictures.

      

    ### 2. What you need

    ASCII art can be done almost anywhere, and with a minimal amount of tools. It's considered the most universal digital artform. However, some of these tools are more fitting for ASCII art or for your style. Some of the links may not work, but you can still locate any of these programs and fonts through [Google](http://www.google.com/).

      

    #### 2a. ASCII art software

    I'm not talking about converters, of course. If you're reading an ASCII art tutorial, you probably want to learn how to do nice and clean images rather than messy conversions. Here you will find programs for MS-DOS, Windows, Linux and Mac. Other platforms often include their own text editors anyway.

    * **Windows Notepad** is a really simple text editor, but it does a good job for small pictures and doodling. It doesn't have the tools and features you will find in a dedicated ASCII art editor, but what's good about it is that you'll find it in any Windows system. Because of its simpleness, Notepad is both a good start for beginners, and a good challenge for experienced ASCII artists.
    * Similar programs: MS-DOS **Edit**, **[Notepad++](http://notepad-plus.sourceforge.net/uk/site.htm)**, **Wordpad**, **[KWrite](http://kde-apps.org/content/show.php?content=9901)** and almost any text editor out there.

    * **[ACiDDraw](http://www.winxtool.com/softdir/util_aciddraw_ansi_editor.htm)** is a very good tool to create textmode art (both ASCII and ANSI). It works on MS-DOS and you have to navigate the menu through the keyboard, but you can still use the mouse to draw. It supports many file formats (ANS, ASC, BIN, etc). Your "canvas" can be up to 160 columns wide and 1000 lines high!

    * Similar programs: **[TheDraw](http://www.syaross.org/thedraw/)** (MS-DOS, predecessor of ACiDDraw), [Duh Draw](http://freshmeat.net/projects/duhdraw/) (for Linux), [TetraDraw](http://tetradraw.sourceforge.net/) (for *nix systems).

    * **[PabloDraw](http://sourceforge.net/projects/pablodraw/)**, a.k.a. **Pablo**, is an ASCII/ANSI editor for Windows. It can emulate [MS-DOS 80x25 font](https://www.roysac.com/tutorial/asciiarttutorial.html#asc2b) (the most common one), the old 80x50 and even Amiga font (a.k.a. [Topaz](https://www.roysac.com/tutorial/asciiarttutorial.html#asc2b)). These three fonts look very good for [solid style](https://www.roysac.com/tutorial/asciiarttutorial.html#asc1a). Like any textmode art editor, it has tools to cut, copy, move and fill areas. It also has an interesting "collaboration mode", in which several artists can chat and work in the same picture through the net. It can work in .txt, .ans, .asc and .bin format, saving regular backups (lots of them). It saves **.ans** files by default, be sure to include the **.txt** extension if you just want a text file. It's pretty fast and reliable. Good for the "old school" look. The only drawback is that you still depend on other programs to save your ASCII art in image files.

    * No similar programs. ;)

    * **[JavE](http://www.jave.de/)** is quite popular. Many people define it as "the Photoshop of the ASCII world". It's far more than a text editor, it has many "undo" levels and it can export your ASCII as an image file. The amount of tools is insane, and goes from the usual brush and fill tools, to 3D modeling and and a converter (that is just as crappy as any other converter). Its textmode edition abilities aren't too different from other editors. The tools are useful for sketches and preview drawings, but they're far from what you can do by hand.

    * Similar programs: [ASCII Art Studio](http://www.torchsoft.com/en/aas_information.html) (shareware), [Email Effects](http://www.sigsoftware.com/emaileffects/) (shareware, available for Mac and Windows)

    ⠀
    I mention these as useful programs for ASCII art. I've tried many, and I'm discarding **Ansipaint** for its lack of usability, as well as most programming-oriented text editors.

      

    #### 2b. Choosing a font

    First of all, you need to use a fixed-width font (or "monospaced" font, it's the same thing). Don't let anyone tell you otherwise. A fixed-width font is a font where all the characters have the same width. The reason why ASCII is always done in fixed width is so that everyone can view it in a similar way. If you make a drawing in Arial, it will look deformed in Times New Roman and completely messed up in Courier.

    Most ASCII editors have a limited handful of fonts you can choose from, but you can always open the file in Notepad to [take a screenshot](https://www.roysac.com/tutorial/asciiarttutorial.html#asc5b) with the font you like. Here's a list of fixed width fonts you can choose:

    * ![](font_courier.gif)
    * Courier / Courier New is a very common font. It comes with Windows, Mac and most Linux distributions. It's the default fixed-width font in most browsers. It doesn't suit very well for large scale ASCII, because it's wide and thin, but the shape of the characters allow for a good [antialiasing](http://notepad-plus.sourceforge.net/uk/site.htm).

    * Mono is a generic font used by some Unix and Linux systems as their default fixed-width font. It's also called Monospace. It's your typical typewriter-like font, very similar to Courier.
    * ![](font_lucidaconsole.gif)
    * Lucida Console comes with Windows 98 and above. It's very thin and doesn't suit for most [solid](https://www.roysac.com/tutorial/asciiarttutorial.html#asc1a) pictures because of its lack of contrast.
    * ![](font_fixedsys.gif)
    * Fixedsys is a bitmap font included in Windows. It's a strong and thick font, a good choice for [solid ASCII art](https://www.roysac.com/tutorial/asciiarttutorial.html#asc1a), but less nice for other styles of ASCII.
    * ![](font_msdos.gif)
    * MS-DOS 80x25 font is also a good choice. It's the font used for most newskool ASCII and ANSI. You can't use it as an actual font in Windows, but you can still use [PabloDraw](http://sourceforge.net/projects/pablodraw/) to emulate it.

    * Terminal comes with some Windows programs and there's a Linux version too. It's similar to MS-DOS 80x25, but smaller. This one *can* be used as a Windows font , but it's a bitmap font, so it shouldn't be resized.
    * ![](font_topaz.gif)
    * Topaz / Topaz New is the font used in Amiga computers, and it's great to draw solid ASCII art, despite being very tall. There's almost no line spacing, but that's not a problem. It's bundled into [PabloDraw](http://sourceforge.net/projects/pablodraw/) and [JavE](http://www.jave.de/), and you can easily download Topaz New from the net to use it in other programs (just [google](http://www.google.com/?q=topaz%2bnew) for it).

    ⠀
    If you're trying a new font, make experiments with it. Draw some simple shapes and see how the characters look like. You will probably have to change or adapt your style from one font to another. Look at this example:


    The circle on the far left was drawn in Courier New. The same circle looks much darker in Fixedsys, and the bottom part is less round because the '+' sign is smaller. The same circle looks flat and jagged in Lucida Console because the '+' sign is too low compared to the quotation marks. It looks more flat in Terminal, even though the proportions between the characters are similar to Courier.


    Some characters look the same in different font, some others vary a lot, for example, the dollar sign, the apostrophe, accents and quotation marks, the 'plus' sign, and above all, the asterisk. The arch above was initially draw in 80x25 font and it looks fine like that. Its height doesn't change when viewed in Topaz, but the apostrophes and accents are bigger than the quotation marks this time, and this breaks the smoothness. The asterisk is much bigger and the dollar sign doesn't work well. In Courier, the asterisk is too small and the apostrophe is straight. Forget about using dollar signs in Courier.

    See the [antialiasing](https://www.roysac.com/tutorial/asciiarttutorial.html#asc3b) section and [working with different fillers](https://www.roysac.com/tutorial/asciiarttutorial.html#asc4a) for more information about choosing proper characters in different situations.

      

    ### 3. The basics

    Many people look at ASCII art and just wonder "where do I start?". That's easy. Open Notepad or your favourite text editor and start making ASCII. Yes, with a keyboard. There is *no* better way. There is no reason to be scared. Your first doodles will probably not make any sense, but Da Vinci's first drawing wasn't a masterpiece either. As long as you start, that's good. The rest of the tutorial will explain you how to draw solid ASCII from the basic sketch to the most advanced techniques. But before going to the specifics, you should keep these advices in mind:

    ```
    d 8 b             ,
     8 8 8            d8
     8 8 8           j88
     Y888P           888
      "8"            888
       8   Drawing   888
       8   everyday   88
      ;8:   objects   88
      j8L  is a good  88
      888   way to    88
      888    begin.   88
      *8*             YP
    ```

    If you use a more complex program than Notepad, you may want to try the options and menus, so that you know your program well before starting. Try to select, move and flip text in PabloDraw or to doodle with the brush in Email Effects . This way you won't be distracted by these options later. It's a good idea to open an ASCII picture created by an experienced artist, look at how it is done, erase some characters and re-draw them in "your style", add some additional objects to the picture and so on. This tutorial is about solid style, so don't use too much detail, try to get the general shape. Don't hesitate to redraw your picture in a higher resolution if you feel like it's too small.

    Try drawing with references, too. You can take an everyday object such as a computer mouse, a bottle or an animal, and wonder how it would look like in ASCII. [JavE](http://www.jave.de/) has a "watermark" tool in which you can set a background picture and draw over it. That can be a good way to learn, even though you should eventually improve and learn to use a reference without drawing over it. Or even better, create your own pictures from scratch.

      

    #### 3a. Sketching

    Not many ASCII artists make "sketches" prior to drawing, but it can be useful to do it, especially if you're attempting a large drawing. During this stage, you use one single character to get a basic shape drawn. You will be able to smooth the picture later. But first, you must choose that unique character to fill the picture, the **filler character**. Here is a list of the most common filler characters and the way you should use them.

    * **8** (eight) is a common filler. It can be used in almost any font, with similar results. It covers the medium and upper area of the line. It suits for almost every picture, especially round shapes.
    * **$** (dollar) is used mostly by demosceners. It's symmetrical and it covers a larger area than 8 because of the upper and lower marks. It's not a good choice if you're not working in MS-DOS font.
    * **S** looks nice in most fonts, especially Courier. It can also be used with **$** (dollar) in MS-DOS font, to create shading.
    * **H** is quite good, it works in almost any font. It's usually darker than the other characters. It doesn't suit for animals, portraits or other round shapes, but it's still good for "square" subjects like buildings and furniture.
    * **@** (at) is often used by converters. It's not a good choice in general. Its shapes varies a lot: in Courier it's round and thin, but in MS-DOS it's narrow and thick.
    * **%** (percent) doesn't work well in most fonts, but you can use it in MS-DOS font for a different level of shading. It's usually weaker than the other characters, so you have to antialiase it in a different way.
    * **:** (colon) is light and small, it works the same way in most fonts, but the picture can be hard to view if you use it as a filler. You can still use it to add a different level of shading, same as for the "percent" sign. See [working with different fillers](https://www.roysac.com/tutorial/asciiarttutorial.html#asc4a) to understand how to handle it.
    * **#** (crosshatch) is very dark and compact in most fonts. Because of this, it enhances the line spacing rather than creating an uniform texture. Try to use **H** instead, unless you need a very, very dark filler.
    * **M / W** are very common, but they're not symmetrical, so they can create undesired "lines" or "gradients" when the picture is viewed from close. There are better choices.
    * **N** looks good in Courier and Lucida Console, it can be a lighter alternative to **M**. But in some fonts, the diagonal line only reaches the middle of the letter, and the results aren't nice. **Z** is similar and it doesn't have that problem, but it's not commonly used.
    * X can be nice. It's a medium or dark filler depending on the font.
    * **I** and | (pipe) are almost identical in some sans-serif fonts, but you can differentiate the letter **I** in serif fonts because it has "feet". See what they look like in your font. They can be useful to create a "striped" texture, but don't use them otherwise.

    ⠀
    Other than that, you can find your own fillers. Try to avoid non-symmetrical characters unless you're looking for a specific effect or texture. If you can't decide, choose **8**, it always looks good. Now that you have a filler character, you can start drawing (yay!).

    ```
    8
             888
           8888
          88888
         888888
         888888
         888888
          8888888
              8
    8888888888888888888
      8888888888888888
      
      Basic sketch
       of a ship
    ```

    Try to have a basic idea in mind. You can make a previous sketch in paper if it feels too hard to start from scratch. Put some characters on the canvas. You can throw some scattered characters and then start refining and filling the shape. The example here shows how I would start an ASCII sketch. I usually start [antialiasing](https://www.roysac.com/tutorial/asciiarttutorial.html#asc3b) along with the sketching, but this time I will sketch the whole picture before moving on to the next step. You can choose the way that feels more comfortable to you. I'll start with a ship because it's simple.

    It looks rather jagged and very unrefined, don't you think? What can we do to make it smoother? Well, here comes the trickiest, but most fascinating technique of ASCII art.

    #### 3b. Antialiasing

    ```
    8888                       ,od88P
       888888                       d8888P
      88888888888888888      8     j88888888888888boo.    b
      888888888888888888888  8     68888888888P***Y8888b. Y:
      88888888            88 88    Y88888P'          `*88bdb
        8888    8888888     888     `8888   ,d88888bo, `*888
        8888  8888888888888  8      ;8?88b,d88888888888b )P'
       88888888      88 8888        j8|8888P'    `YP`Y88b'
      8888888        8  8888        88:887'        " `88P
      888888             88        ;88 88             YP'
      8888888             8        j88 88b            `L
      88888888                     688 888bo.          Y
      88888888888                  888 888888>         `
      8888888888      8888         "*'j88888P    d8888P'
      888888888               =>    od888889      `"P'
      88888888     88888            8888888'    ,od8b,
      8888888                       888888P         ``
      88888                   =>    8888"V
      888888                        8888b,
      88888888                      888888b,
      88888888888                   `888888888bo,,
      88888888888888888              88888888888888P"'
      88888888888888888             j88888888888888L
     888888888888888888            d8888888888888888b js
    ```

    **Antialiasing** plays a crucial role in most low-resolution artforms (not only ASCII art, but ANSI and pixel art as well). The example here shows how that silhouette made of 8's turns into a sharper moai-ish figure.

    Antialiasing is to add additional characters to make the outlines smoother. An antialiased picture has more accurate borders than a picture made of a single character. Antialiasing allows you to add more detail and create more interesting shapes.

    The following chapters will be focused on how to get a better antialiasing, so be patient. Don't get lost trying to use as many characters as possible, it's better to have a simple palette of no more than ten characters, and then make changes as needed. The key is to understand the characters and their shapes, then place them as needed.

    ![](antialiasing_translating.gif) 

    This is my technique. When you're working in textmode, there's an imaginary grid of columns and rows in which you type characters, right? As you type, try to go visualizing the shape you will try to fit into that grid. Take into account details such as how high or low the characters are, how slanted you want the lines to be. Evaluate each space in the canvas and then translate the desired shape to the most fitting character. In this diagram, the upper rows show the desired shapes, and the lower rows show some antialiasing characters you can use. There are many more choices, and you will probably find better antialiasing characters than me. It's a matter of style.

    Some people draw an actual grid over a reference picture, and then translate the characters one by one in a text editor. Most of the time, you won't need a grid for that, you can do it directly from your mind. It probably sounds time-consuming or plain impossible, but it's enough to remember that graphic I showed you. After a few minutes, antialiasing should come naturally to you. You usually don't spend more than one second thinking bout the appropriate characters to place. However, there are some tricky situations.

    **P** works well for most lower right curves and so do **7** and **F**, but there are no similar characters for the left side (**q** is too low). **Y** is closer. Some people use **+** (plus) too, or even **<** and **>**. **V** is not that good for that, its shape varies a lot. **b** and **d** are good in solid ASCII, but they will probably look dark if you use a light filler. It's the kind of things you should take into account when you're antialiasing. The rest of the tutorial will mention these issues in detail. Let's make some ASCII then.


    Let's say we want to draw a heart (aww). We start by visualizing the heart into the picture (1). Use your imagination and draw a sketch accordingly (2). You can use a brush tool or just type, after all, it's a sketch. Now we move on to the antialiasing (3). Notice how the 8's have been replaced by big characters like **b**, **d**, **P** and **Y**. The rest of the lines were smoothed by adding quotation marks, commas and dots. Commas are nice because they go with the flow of the line, but there's no equivalent for the right side, so we use dots instead. I didn't want to use accents instead of quotation marks because they look almost invisible in Courier. The final touch is a **v** to represent the crease in the middle of the heart. We have here a nice and simple ASCII done in less than a couple of minutes (4).

      

    #### 3c. Straight lines

    After a short while of creating ASCII, the basic shapes should come to you naturally, without the need to think a lot about how to get the proper antialiasing. For example, straight diagonal slopes. It is suggested that you use this chapter as a reference, rather than something you have to learn by heart. You can even [skip it](https://www.roysac.com/tutorial/asciiarttutorial.html#asc4) to make the reading easier.

    ```
    d88888888 88888888b
      d888888888 888888888b
     d8888888888 8888888888b
    d88888888888 88888888888b
    ```

    ```
    j88888888 88888888L
      j888888888 888888888L
     j8888888888 8888888888L
    j88888888888 88888888888L
    ```

    Two ways to create antialiasing on upper slanted slopes. Just as easy as that. The first one works well in most fonts, but the result isn't always optimal. The second one is best for MS-DOS font, but as you can see, it doesn't look that good in Courier. Anyway, the process is the same: we work by placing the right antialiasing characters in a diagonal pattern.

    ```
    Y88888888888 88888888888P
     Y8888888888 8888888888P
      Y888888888 888888888P
       Y88888888 88888888P
    ```

    ```
    \\88888888888 88888888888F
     \\8888888888 8888888888F
      \\888888888 888888888F
       \\88888888 88888888F
    ```

    The same is done for lower lines. **P** is a common choice for the right side and **F** works too. However, the left side is problematic. **Y** is the best we can find, but sometimes **\\** (slash) can fit well enough (if you don't mind the hard border it creates). Even **?** can give good results for either side depending on the font.

    And here's the only thing you have to remember. What if we want to change the degree of the slope? The key is to **add or remove antialiasing characters on each line** (and spaces as needed). The more characters you add, the more horizontal the line will be, and vice versa. Let's see how it works.

    ```
    ,d8888 8888b.
        ,d888888 888888b.
      ,d88888888 88888888b.
    ,d8888888888 8888888888b.
    ```

    ```
    ,48888 8888h.
        ,4888888 888888h.
      ,488888888 88888888h.
    ,48888888888 8888888888h.
    ```

    Now, the line is less vertical, and look how sharp it is. On the first example, the **d** and **b** remain unchanged, all we did was to add dots and commas to keep the shape of the line. The second example will probably look a little better, especially the **4**'s because they are straight. Be warned, however, this doesn't work in fonts where the **4** is "open" on the top. **h** isn't too different from **b**.

    ```
    "88888888888 8888888888P"
      "888888888 88888888P"
        "8888888 888888P"
          "88888 8888P"
    ```

    It's not that easy to do it on lower slopes. The left side is always tricky. The accent and the apostrophe would probably look nice and make the lines smoother too, but not in Courier. Using **q** sounds like an alternative, but it's too low. The quotation marks alone are the best choice in this case. Don't worry about the **8**, it's round and it works. On the right side, you can still use **P** to antialiase further, but the difference is minimal.

    ```
    ,<8 8>.
          ,<8888 8888>.
       ,<8888888 8888888>.
    ,<8888888888 8888888888>.
    ```

    ```
    ,o8 8n.
          ,o8888 8888n.
       ,o8888888 8888888n.
    ,o8888888888 8888888888n.
    ```

    Let's make these lines longer. It's easier now that we know how. One additional space, the right characters, and it's done. What do you think of the **<** and **>** signs? I think they're perfect to get sharp borders, but they're too light. Oh well, sometimes you have to make sacrifices, and in this case, we're sacrificing the **consistency** of the picture to get more **sharpness** in the edges. When you're working in small drawings, it's better to have sharp edges like in the first image, because they still look good when viewed from close. But in big pictures, consistency is more important to the eye, so you'd rather choose the second example. **o** and **n** are dark, solid and round enough for a decent antialiasing. **o** can be used in either side, but **n** suits better for the right one.

    ```
    "<8888888888 8888888888>"
       "<8888888 8888888>"
          "<8888 8888>"
             "<8 8>"
    ```

    ```
    "?8888888888 8888888888?"
       "?8888888 8888888?"
          "?8888 8888?"
             "?8 8?"
    ```

    The lower part follows the same pattern. We could also use **?** as an alternative, because the dot gives the illusion that the character is placed higher. In some fonts, the ***** (asterisk) is big and high enough to be used for this. 

    ```
    __,,ood8
            __,,ood888888888
    __,,ood88888888888888888

    ``""**??8888888888888888
              ``""**??888888
                        ``""
    ```

    We have seen slopes in three different degrees, but you will probably like to find your own, at will. Don't be afraid of **repeating the characters** until you get a smooth line. In the example shown here, we use some characters twice to achieve the right degree. It works especially well on the lower slope, where we have a nice variety of characters for the different heights. Using this technique, you can get your lines to be as slanted as you need. 

    But then, what if we wanted to make our lines higher? There's a wide variety of characters of different heights to create nice horizontal slopes, but almost none for vertical ones. The best option is to **create vertical gradients** to trick the eye.

    ```
    A8 8A
     ;88 88;
     A88 88A
    ;888 888;
    A888 888A
    ```

    ```
    Y888 888Y
    :888 888:
     Y88 88Y
     :88 88:
      Y8 8Y
    ```

    The **A** is slanted enough, and the **;** (semicolon) works as a gradient because it's darker on its lower part. The opposite can be done with **Y** and **:** (colon). Sometimes you can also use **V** instead if **Y**. If you're drawing in a high resolution, the illusion will be perfect and the antialiasing will look decent. However, in a small resolution, it becomes too obvious and it doesn't look good. In that case, it would be better to make a straight vertical line instead.

    ```
    ;88 88;
     ]88 88[
     A88 88A
    ;888 888:
    ]888 888[
    A888 888A
    ```

    ```
    Y888 888Y
    ]888 888[
    :888 888:
     Y88 88Y
     ]88 88[
     :88 88:
    ```

    You can make your slopes as vertical as you wish, but use this technique carefully. The longer the gradients, the less polished the line will be. Gradients are more suited for **grayscale** (gradient-shaded) ASCII art, and therefore don't give good results in [solid](https://www.roysac.com/tutorial/asciiarttutorial.html#asc1a). Use brackets, pipes or other solid characters when possible.

    Phew! That's all about making straight lines in solid style. Now I feel like I could make them solid as steel! :D

      

    ### 4. Drawing like a pro

    OK, now you've probably been drawing in ASCII for a while, and you want to spice up your pictures. If this is the case, here are some advanced techniques. You will probably not assimilate them easily if you have not created ASCII art before, but any day is a good day to try. :)

      

    #### 4a. Working with different fillers

    ```
    ,od8bo.
       ,d8888888L
      d8888888888b.
      8888888888888b
    . Y8888888888888
    :: *8888888888P",:         :.     .
    :::. YL88 dF ,.::::      ,:::.   ,:
    ::::: "88dF ::::::::. .,:::::::.:::
    '''''' 88F ::::::::::::::::::::::::
    @@@@++ 88 ,_'''''::::::::::::::''''
    @@@@@' 88 @@@@+++,,.__''''__,,,++@@

        
        **8** is the most common filler, but sometimes you need to add different levels of depth and shading, like in this landscape. Some may consider this to be grayscale ASCII, but it's still an array of solid shapes with different fillers.
        
        If you look closely, you'll see that we use four different fillers:
        
        * **8**, for the tree, is a default choice.
          * **H**, for the foreground slope, is darker than average, and suits very well for strong, remarkable elements.
            * **@** (at) for the next slope, doesn't look the same in most fonts, but it works well enough in Courier Bold. It's clearer than average here.
              * **:** (colon) is the lightest character. Good for seemingly foggy backgrounds, and light shapes in general.
           


    You're on the right track with your Safari Web Extension! Let's break down your goal and implement a minimal Dark Mode extension step by step. The goal is to:

    1. **Add a title and toggle in the popup HTML** for enabling/disabling Dark Mode.
    2. **Inject CSS into the current web page** to override the `body` background to dark when Dark Mode is enabled.

    Here’s how you can achieve this:

    ---

    ### 1. Update `popup.html`

    Add a title and a toggle button to your `popup.html`:

    ```html
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="popup.css">
        <script type="module" src="popup.js"></script>
    </head>
    <body>
        <h1>Dark Mode</h1>
        <label class="switch">
            <input type="checkbox" id="darkModeToggle">
            <span class="slider"></span>
        </label>
    </body>
    </html>
    ```

    ---

    ### 2. Style the Toggle in `popup.css`

    Add styles for the toggle switch and the popup:

    ```css
    :root {
        color-scheme: light dark;
    }

    body {
        width: 150px;
        padding: 10px;
        font-family: system-ui;
        text-align: center;
    }

    h1 {
        font-size: 16px;
        margin-bottom: 10px;
    }

    /* Toggle Switch */
    .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
    }

    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        transition: 0.4s;
        border-radius: 34px;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        transition: 0.4s;
        border-radius: 50%;
    }

    input:checked + .slider {
        background-color: #2196F3;
    }

    input:checked + .slider:before {
        transform: translateX(26px);
    }
    ```

    ---

    ### 3. Add Logic in `popup.js`

    Add logic to handle the toggle button and send a message to the content script to inject CSS:

    ```javascript
    // Get the toggle button
    const toggle = document.getElementById('darkModeToggle');

    // Listen for toggle changes
    toggle.addEventListener('change', () => {
        const isDarkMode = toggle.checked;

        // Send a message to the content script
        browser.tabs.query({ active: true, currentWindow: true }).then((tabs) => {
            browser.tabs.sendMessage(tabs[0].id, { darkMode: isDarkMode });
        });
    });
    ```

    ---

    ### 4. Inject CSS in `content.js`

    Update `content.js` to listen for messages and inject CSS into the current page:

    ```javascript
    // Listen for messages from the popup
    browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
        if (request.darkMode !== undefined) {
            // Toggle Dark Mode
            if (request.darkMode) {
                // Inject dark mode CSS
                document.body.style.backgroundColor = "#121212";
                document.body.style.color = "#ffffff";
            } else {
                // Revert to default styles
                document.body.style.backgroundColor = "";
                document.body.style.color = "";
            }
        }
    });
    ```

    ---

    ### 5. Update `manifest.json`

    Ensure your `manifest.json` has the necessary permissions and matches for all URLs:

    ```json
    {
      "manifest_version": 3,
      "default_locale": "en",

      "name": "__MSG_extension_name__",
      "description": "__MSG_extension_description__",
      "version": "1.0",

      "icons": {
        "48": "images/icon-48.png",
        "96": "images/icon-96.png",
        "128": "images/icon-128.png",
        "256": "images/icon-256.png",
        "512": "images/icon-512.png"
      },

      "background": {
        "scripts": [
          "background.js"
        ],
        "type": "module"
      },

      "content_scripts": [
        {
          "js": [
            "content.js"
          ],
          "matches": [
            "<all_urls>"
          ]
        }
      ],

      "action": {
        "default_popup": "popup.html",
        "default_icon": "images/toolbar-icon.svg"
      },

      "permissions": [
        "activeTab",
        "scripting"
      ]
    }
    ```

    ---

    ### 6. Test Your Extension

    1. Load your extension in Safari:
       - Open Safari.
       - Go to `Preferences > Extensions`.
       - Enable "Develop Menu" in `Preferences > Advanced`.
       - Use `Develop > Show Extension Builder` to load your extension.

    2. Click the extension toolbar button to open the popover.
    3. Toggle the switch to enable/disable Dark Mode on the current page.

    ---

    ### 7. Optional: Persist Dark Mode State

    If you want to persist the Dark Mode state across page reloads or browser sessions, you can use `browser.storage.local`:

    - In `popup.js`, save the state:
      ```javascript
      toggle.addEventListener('change', () => {
          const isDarkMode = toggle.checked;
          browser.storage.local.set({ darkMode: isDarkMode });
      
          browser.tabs.query({ active: true, currentWindow: true }).then((tabs) => {
              browser.tabs.sendMessage(tabs[0].id, { darkMode: isDarkMode });
          });
      });
      
      // Load saved state
      browser.storage.local.get("darkMode").then((result) => {
          toggle.checked = result.darkMode || false;
      });
      ```

    - In `content.js`, apply the saved state on page load:
      ```javascript
      browser.storage.local.get("darkMode").then((result) => {
          if (result.darkMode) {
              document.body.style.backgroundColor = "#121212";
              document.body.style.color = "#ffffff";
          }
      });
      ```

    ---

    ### Summary

    You now have a minimal Safari Web Extension that:
    - Displays a toggle in the popover.
    - Injects CSS to enable/disable Dark Mode on the current page.
    - Optionally persists the Dark Mode state.

    This is a great starting point, and you can expand it further by adding more advanced CSS rules, preferences, or even a settings page in the companion app. Let me know if you need further assistance!     
    """
  }
  
  
  
}
