// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - Optional bindings
/// By SwiftfulThinking
public extension Optional where Wrapped == String {
    var _boundString: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    var boundString: String {
        get {
            return _boundString ?? ""
        }
        set {
            _boundString = newValue.isEmpty ? nil : newValue
        }
    }
}

public extension Optional where Wrapped == Int {
    var _boundInt: Int? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    var boundInt: Int {
        get {
            return _boundInt ?? 0
        }
        set {
            _boundInt = (newValue == 0) ? nil : newValue
        }
    }
}
public extension Optional where Wrapped == Bool {
    var _boundBool: Bool? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    var boundBool: Bool {
        get {
            return _boundBool ?? false
        }
        set {
            _boundBool = (newValue == false) ? nil : newValue
        }
    }
}

//func ??<Bool>(lhs: Binding<Optional<Bool>>, rhs: Bool) -> Binding<Bool> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}

// MARK: - Random colour
public extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// MARK: - Visual effect
#if os(macOS)
public struct VisualEffectView: NSViewRepresentable {
    public func makeNSView(context: Context) -> NSView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground
        return view
    }
    public func updateNSView(_ view: NSView, context: Context) { }
}
#endif


// MARK: - Check if is Preview
public var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}



public func downloadImage(from url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Check for a valid HTTP response
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    return data
}



#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif


public extension Image {
    init?(data: Data) {
#if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
#elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        self.init(nsImage: nsImage)
#endif
    }
}

//#if canImport(UIKit)
//extension UIImage {
//    var cgImage: CGImage? {
//        return self.cgImage
//    }
//}
//#endif

#if canImport(AppKit)
public extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect(origin: .zero, size: self.size)
        return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
#endif



public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}


public extension Collection {
    func prettyPrinted<T>(keyPaths: [KeyPath<Element, T>]) -> String {
        var result = "[\n"
        for element in self {
            let values = keyPaths.map { keyPath in
                return "\(element[keyPath: keyPath])"
            }.joined(separator: ", ")
            result += "    \(values),\n"
        }
        result += "]"
        return result
    }
}

public extension Collection where Element == (key: String, value: Int) {
    func prettyPrinted(
        delimiter: String = ".",
        keyFirst: Bool = true,
        stripCharacters: Bool = false
    ) -> String {
        var result = "Headers:\n\n"
        for element in self {
            let key = stripCharacters ? element.key.filter { !$0.isWhitespace && $0.isLetter } : element.key
            let value = element.value
            if keyFirst {
                result += "\(value)\(delimiter) \"\(key)\"\n"
            } else {
                result += "\"\(key)\"\(delimiter) \(value)\n"
            }
        }
        return result
    }
}




public extension String {
    var wordCount: Int {
        let words = self.split { !$0.isLetter }
        return words.count
    }
}


public extension Array where Element: Equatable {
    func indexOf(_ item: Element?) -> Int? {
        
        if let item = item {
            return self.firstIndex(of: item)
        } else {
            return nil
        }
    }
    
    func nextIndex(after item: Element?) -> Int? {
        guard let currentIndex = self.indexOf(item) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < self.count ? nextIndex : nil
    }
    
    func previousIndex(before item: Element?) -> Int? {
        guard let currentIndex = self.indexOf(item) else { return nil }
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? previousIndex : nil
    }
    
    func secondToLast() -> Element? {
        if self.count < 2 {
            return nil
        }
        let index = self.count - 2
        return self[index]
    }
}

//import AppKit
#if os(macOS)

public struct EscapeKeyDoubleTapModifier: ViewModifier {
    var action: () -> Void
    var bufferMilliseconds: Int
    
    @State private var lastEscapePressDate: Date?

    public func body(content: Content) -> some View {
        content
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
                    self.handle(event: event)
                    return event
                }
            }
    }
    

    
    private func handle(event: NSEvent) {
        guard event.keyCode == 53 else {  // 53 is the keycode for Escape
            return
        }

        let now = Date()
        
        if let lastPress = lastEscapePressDate, now.timeIntervalSince(lastPress) * 1000 < Double(bufferMilliseconds) {
            action()
            lastEscapePressDate = nil // reset after action
        } else {
            lastEscapePressDate = now
        }
    }
}

public extension View {
    func onEscapeKeyDoubleTap(bufferMilliseconds: Int = 300, perform action: @escaping () -> Void) -> some View {
        self.modifier(EscapeKeyDoubleTapModifier(action: action, bufferMilliseconds: bufferMilliseconds))
    }
}

#endif

public extension CGFloat {
    func displayAsInt() -> String {
        return String(format: "%0.f", self)
    }
}

public extension Double {
    func displayAsInt() -> String {
        return String(format: "%0.f", self)
    }
}

public extension Comparable {
    func constrained(_ minValue: Self, _ maxValue: Self) -> Self {
        return min(max(self, minValue), maxValue)
    }
}

public extension Comparable where Self: FloatingPoint {
    func normalised(from originalRange: (min: Self, max: Self)) -> Self {
        guard originalRange.min < originalRange.max else { return self }
        return (self - originalRange.min) / (originalRange.max - originalRange.min) * 100
    }
}

public extension Int64 {
    func getString() -> String {
        return String(self)
    }
}

extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
