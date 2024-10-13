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
    import Scrolling
    
    struct MessageInputView: View {
    
    @Environment(\\.store) private var store
    
    @State private var metrics: String = ""
    @State private var isManualMode: Bool = false
    
    //  @State private var editorHeight: CGFloat = .zero
    
    @Bindable var conversationStore: StoreOf<SingleConversation>
    
    let syntaxButtons: [Markdown.Syntax] = [.bold, .italic, .inlineCode]
    
    @FocusState var focused: Focus.State.Element?
    
    //  @Bindable var conversation: StoreOf<SingleConversation>
    
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
        # This is the beginning of a really long heading so i can see what it does
        ## Second heading
        ### Third heading yay
        
        I will build a library of `Message` objects, as `[String]`, and can ~~you write~~ me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.
        
        ```swift
        let highlightr = Highlightr()
        highlightr?.setTheme(to: "xcode-dark-butts")
        ```
        
        - I `think this is something` worth thinking about in the context of all tooling we use. 
        - If I do my job correctly with the IDE, you shouldn't be thinking about much outside of the program you're writing. 
        - The goal is to keep you focused, so you never have to stop and reach for the documentation of the IDE, or Zig itself. Based on what you're doing
        
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
    
    
  }
  
}
