
# `ScrollGeometry` glossary:

## `bounds: CGRect`:
The bounds rect of the scroll view.
Unlike `visibleRect`, this value is *within* the content insets of the scroll view.

## `containerSize: CGSize`:
The overall size of the scroll view (not the content)
Combining `containerSize` + `contentOffset` = `visibleRect`

## `contentInsets: EdgeInsets`
Combining `contentInsets` + `contentSize` = total scrollable space

## `contentOffset: CGPoint`
The position of the scroll view within its overall content size.
May give value below `zero` or beyond the `contentSize` when
`contentInsets` are non-zero, or when rubber banding.

`contentOffset < 0`: 
`contentOffset == 0`: 
`contentOffset > 0`: 


## `contentSize: CGSize`
Unlike `containerSize`, this refers to the total size of the content
Can be smaller or larger than its containing size

## `visibleRect: CGRect`
Computed from `contentOffset`, `contentInsets`, and `containerSize`

Extracting useful scroll behaviour

Some useful scroll metrics to track:
- Is content overflowing at all — need a good concise phrasing for this.
  This just means; is the length of the content (whether vertical or
  horizontal) more than the scroll container itself.
- Are we scrolled to the start, end, or somewhere in the middle of the content
  These are only relevant when the above is true, when there *is* overflow
- Do we keep these seperate from the 'more advanced' things like
  the position of identified sub views, within the scroll view?

It might be good to find a way to establish the depth or type of metrics
needed, and then only listen for data required for that. As scroll events
can be expensive. Consider how **debouncing** could help with this.

Examples of applications of these metrics

- Scroll masking: Fading content out on one/both of the ends of a view,
  as it scrolls past the edge of it's container
- Tracking / binding to scroll position of views to highlight/navigate to views etc
- Detecting scroll phase/offset to drive behaviour of *other* views, such as
  showing/hiding a toolbar background when content scrolls far enough

