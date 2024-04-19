//
//  ExampleText.swift
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

struct ExampleText {
    
    static let basicMarkdown: String = """
        # This is the beginning of a really long heading so i can see what it does
        ## First, a message
        ### And a third, a header that's small
        I will build a library of `Message` objects, as `[String]`, and can you write me up a *function* that simply selects one of the **paragraphs** (i.e. items in the array), and returns it? Also, we need some ***extra emphasis*** on this text.
        
        ```
        func updateNSView(_ nsView: NSTextView, context: Context) {
            nsView.textStorage?.setAttributedString(text)
        }
        ```
        
        As well as some text down here.
        
        And some here just in case
        """
    static let paragraphs: [String] = [
        """
        *** Test Response ***
        Could you come up with a function for me, for SwiftUI, that will generate a paragraph or two, with some tweakable parameters for paragprah count, and word count? I dont mind what the words are, they jsut need to look like natural language. Feel free to even supply actual static blocks of strings — actually let’s do that. I will build a library of parapgraphcs, as `[String]`, and can you write me up a function that simply selects one of the paragraphis (i.e. items in the array), and returns it?
        """,
        """
        *** Test Response ***
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
        *** Test Response ***
        ### Considerations:
        - **Performance**: If your app needs to display a large number of messages or very frequent updates, consider the performance implications of using `NSTextView`, as it might be heavier than simpler views like `Text` in SwiftUI.
        - **Consistency**: Using the same component (`NSTextView`) across your app for both input and display can lead to a more consistent implementation and styling approach.
        - **Integration with SwiftUI**: If you are using SwiftUI and need to integrate `NSTextView`, you can use `NSViewRepresentable` to wrap `NSTextView` for use within SwiftUI views.
        
        """,
        
        """
        *** Test Response ***
        Using `NSTextView` in your macOS app for both input and display of messages can be a viable option, especially if you want to leverage its rich text capabilities and the ability to use attributed strings for advanced styling. Here are some considerations and steps for using `NSTextView` as a read-only component for displaying messages:
        
        ### Advantages of Using `NSTextView`:
        1. **Rich Text Features**: `NSTextView` supports rich formatting options, which can be beneficial if you want to display messages with varied styles or embedded links.
        2. **Attributed Strings**: Since you already have a library for regex-driven attributed strings, `NSTextView` can directly utilize these, allowing for consistent text styling across your application.
        3. **Customization**: `NSTextView` offers extensive customization options, which can be tailored to fit the look and feel of your app.
        
        ### Making `NSTextView` Read-Only:
        To use `NSTextView` for displaying static messages, you need to configure it to be non-editable and non-selectable if you don't want users to interact with the text beyond reading:
        
        """,
        
        """
        *** Test Response ***
        ### Key Points:
        
        1. **Regex Pattern**: The pattern `"`.*?`"` is used to match text including the backticks.
        2. **Attributed String**: We create an `AttributedString` from the plain text and apply attributes to parts of the text that match the regex pattern.
        3. **Styling**: The text within backticks, including the backticks themselves, is styled with the specified attributes (red color and bold font in this case).
        
        This approach allows you to include and style the backticks along with the text they enclose, directly within your SwiftUI view.
        """,
        """
        *** Test Response ***
        Thanks!
        
        Could you explain 'non-greedy’?
        
        Also, how would you suggest i could *include* the backticks, so they are caught in the styled attributed string?
        """,
        """
        *** Test Response ***
        1. **Regular Expression**: The pattern `("```\\n)(.*?)(\\n```")` is used to match blocks of text that start and end with triple backticks, considering the line breaks. It uses `.*?` for non-greedy matching of any characters between the backticks, including new lines due to the `.dotMatchesLineSeparators` option.
        
        2. **Text Attributes**: The code applies several attributes to the matched text:
           - `.foregroundColor`: Changes the text color inside the code blocks.
           - `.font`: Applies a monospaced font to make code more readable.
           - `.backgroundColor`: Adds a background color to highlight the code block.
        
        3. **Safe Updating**: It preserves the user's selected text range before and after applying the styles, which is crucial for maintaining the text view's state.
        
        This function should be called in appropriate places, such as after the text changes in the `NSTextView`. This way, it will style the code blocks dynamically as the user types or modifies the existing text.
        """,
        """
        *** Test Response ***
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
        *** Test Response ***
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
        *** Test Response ***
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


let bigText = """

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
