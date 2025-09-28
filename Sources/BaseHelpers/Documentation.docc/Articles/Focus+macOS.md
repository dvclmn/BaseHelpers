# Focus for macOS

Some notes on the best luck I've had managing focus for macOS

## Focus-reliant ViewModifiers
Examples: `onSubmit()`, `onMoveCommand`, `onKeyPress()` etc.

Notes on how to implement these correctly:

- Place `focusable()` on a *parent* View, higher up the hierarchy
- This will allow use of `EnvironmentValue/isFocused` in the child View(s)
- Modifiers that rely on the View being focusable (including `.focusEffectDisabled()`) must be placed *after* `.focusable()`.

Example:

```swift
ZStack {
  ExampleView()
}
.focusable(isFocusable)
.focusEffectDisabled()
.onMoveCommand { direction in ...}
.onKeyPress(.return, phases: .down) { keyPress in ...}
```

```swift
public struct ExampleView: View {
  @Environment(\.isFocused) private var isFocused

  public var body: some View {
    Text(isFocused ? "View is Focused" : "View not Focused")
  }
}
```


