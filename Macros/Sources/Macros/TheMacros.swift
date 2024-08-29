import Foundation

/// A macro that produces an unwrapped URL in case of a valid input URL.
/// For example,
///
///     #URL("https://www.avanderlee.com")
///
/// produces an unwrapped `URL` if the URL is valid. Otherwise, it emits a compile-time error.
///
@freestanding(expression)
public macro URL(_ stringLiteral: String) -> URL = #externalMacro(module: "Macros", type: "URLUnwrapMacro")
