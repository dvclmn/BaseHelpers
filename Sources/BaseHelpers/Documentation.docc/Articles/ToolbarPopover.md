I've had difficulty getting popovers to behave properly on macOS, when added to a Button in the toolbar.

The issue:
Clicking the Toolbar button to invoke, then clicking again to dismiss, would cause the popover to hide then rapidly show again.

The solution:

Add the `.popover()` modifier to the *Button*, not the Label inside the Button. This is where I was going wrong.

```swift
Button {
  if !store.isShowingMoreOptions {
    store.isShowingMoreOptions = true
  }
} label: {
  Label("More Options", systemImage: Icons.ellipsis.icon)
}
.popover(isPresented: $store.isShowingMoreOptions) {
  MoreOptionsView()
}

```
