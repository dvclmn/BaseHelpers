
# Markdown Syntax
A brief overview of syntax types support by this editor

## Headings


```md
# Example heading 1
## Example heading 2
### Example heading 3
```
> Note: Underline-style headings considered for possible future support:
>
>```md
> Heading
>=======
>
>Sub-heading
>-----------
>```

- term Layout: Block (single line)
- term Syntax: Leading

> Note: Single-line Block types may span multiple lines *only* when wrapping. Otherwise, a new line signifies the start of a new markdown element.

---

## Bold and italic

```md
**Bold text with asterisks**
__Bold text with underscores__

*Italic text with an asterisk*
_Italic text with an underscore_

**Bold text with _italic text_ nested**
*Italic text with __bold text__ nested*

***Bold Italic text***
___Bold Italic text___
```

- term Layout: Inline
- term Emphasis style: Asterisk (\*) and underscore (\_)
- term Syntax: Enclosed (symmetrical)

---

## Other inline styles


```md
`inline code`
~~strike-through text~~
==highlighted text==
```

- term Layout: Inline
- term Syntax: Enclosed (symmetrical)

---

## Lists

### Unordered lists


```md
- List item 1
- List item 2
- List item 3

* List item 1
* List item 2
* List item 3

+ List item 1
+ List item 2
+ List item 3
```


### Ordered lists

```md
1. List item 1
2. List item 2
3. List item 3

1) List item 1
2) List item 2
3) List item 3

a. List item 1
b. List item 2
c. List item 3
```


### Task lists

```md
[ ] Todo item 1
[x] Todo item 2
[ ] Todo item 3
```


### Mixed styles / nesting

```md
1. List item 1
[x] Nested todo 1
[x] Nested todo 2
[ ] Nested todo 3
2. List item 2
3. List item 3
- Nested item 1
- Nested item 2
```

- term Layout: Block (single line)
- term Syntax: Leading


---


## Quotes

```md
> Quoted text

> Multi-line quotes can
> be achieved with multiple
> greater-than symbols
```

- term Layout: Block (single line)
- term Syntax: Leading


---

## Links and images

```md
[link label](http://link.url)

![image label](http://image.url)
```

- term Layout: Inline
- term Syntax: Enclosed (asymmetrical)


---

## Code blocks


```md
(three backticks)(language hint)
var count: Int = 0
(three backticks)
```
- term Layout: Block (multi-line)
- term Syntax: Enclosed (asymmetrical)


---


## Horizontal rule

```md
---

***
```

- term Layout: Block
- term Syntax: 


## Regex


The attributed range as described below, pairs with the `ThreePartRegex` above,
and provides a mechism through which to identify where in the
`AttributedString` the resulting matches are located.

```
public typealias AttributedRange = Range<AttributedString.Index>
```

The first `Substring` is reserved for the full match. The subsequent three can be used
in whatever way makes sense. E.g. for content surrounded by syntax, such as `*italics*`.

In that example, substrings 2, 3 and 4 would hold the leading asterisk, text content,
and trailing asterisk respectively.

`public typealias ThreePartRegex = Regex<(Substring, Substring, Substring, Substring)>`

