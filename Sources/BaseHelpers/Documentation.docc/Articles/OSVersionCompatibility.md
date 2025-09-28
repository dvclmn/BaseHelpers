# OS Version Compatibility

Notes on handling `if #available(macOS 15.0, *) {...}` properly

```
struct HideBackgroundModifier: ViewModifier {
    @ViewBuilder func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}
extension View {
    func hideBackground() -> some View {
        self.modifier(HideBackgroundModifier())
    }
}
```
