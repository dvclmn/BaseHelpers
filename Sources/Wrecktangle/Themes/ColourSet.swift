//
//  ColourSet.swift
//  BoxCore
//
//  Created by Dave Coleman on 24/8/2024.
//

import SwiftUI

/// ColourSet is not yet public, still working on it
/// 
extension BoxCore.Theme {
  
  struct ColourSet: Sendable {
    private var colors: [ColourCategory: Attributes]
    
    public init(
      primary: Color,
      secondary: Color,
      tertiary: Color,
      accent: Color
    ) {
      self.colors = [
        .primary: Attributes(foreground: primary),
        .secondary: Attributes(foreground: secondary),
        .tertiary: Attributes(foreground: tertiary),
        .accent: Attributes(foreground: accent)
      ]
    }
    
    /// `subscript` is a shorthand way to access elements in a collection.
    /// It allows the use of square bracket notation `[]` to get or set values.
    /// Further reading: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/subscripts/`
    ///
    /// In our case, it allows us to access `Attributes` objects using `ColorCategory` as an index. For example:
    ///
    /// ```swift
    /// let primaryColor = myColourSet[.primary]
    /// ```
    ///
    
    public subscript(category: ColourCategory) -> Attributes {
      get { colors[category] ?? Attributes(foreground: .primary) }
      set { colors[category] = newValue }
    }
    
    
    public mutating func updateColor(for category: ColourCategory, foreground: Color, background: Color? = nil) {
      colors[category]?.foreground = foreground
      colors[category]?.background = background
    }
    
    
    
    /// This method provides an alternative way to retrieve `Attributes` for a given category.
    ///
    /// Usage example:
    ///
    /// ```swift
    /// let secondaryColor = myColourSet.color(for: .secondary)
    /// ```
    ///
    public func color(for category: ColourCategory) -> Attributes {
      colors[category] ?? Attributes(foreground: .primary)
    }
  }
  
  enum ColourCategory: String, Identifiable, Sendable {
    case primary    /// Text
    case secondary  /// Box frame
    case tertiary   /// Invisibles
    case accent     /// Subtle accents
    
    public var id: String {
      self.rawValue
    }
  }
  
  /// `Attributes` holds an `AttributeContainer` instance, which
  /// holds all the styles for the set.
  ///
  /// I find `AttributeContainer`s somewhat clumsy to make, so this type
  /// abstracts this job away from the user. Also, `BoxCore` (currently) only
  /// really needs foreground/background colours, so having `AttributeSet`
  /// makes that more accesible/straightforward.
  ///
  /// We can rely on the computed property `container` to return an *actual*
  /// container when we need it.
  ///
  
  struct Attributes: Sendable {
    var foreground: Color
    var background: Color?
    
    init(foreground: Color, background: Color? = nil) {
      self.foreground = foreground
      self.background = background
    }
    
    var container: AttributeContainer {
      var attrContainer = AttributeContainer()
      attrContainer.foregroundColor = self.foreground
      attrContainer.backgroundColor = self.background
      return attrContainer
    }
  }
  
  
  
}
