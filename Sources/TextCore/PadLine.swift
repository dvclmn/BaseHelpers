//
//  PadLine.swift
//  TextCore
//
//  Created by Dave Coleman on 29/8/2024.
//

import SwiftUI
import Foundation

public typealias StringCaps = (leading: String, trailing: String)

public enum PaddedContentType {
  case text
  case cap
}

public struct LineCaps {
  var leading: String
  var trailing: String
  var hasExtraSpaces: Bool
  
  public init(
    _ leading: String,
    _ trailing: String,
    hasExtraSpaces: Bool = true
  ) {
    self.leading = leading
    self.trailing = trailing
    self.hasExtraSpaces = hasExtraSpaces
  }
}

public struct TextCore {
  
  static public func padLine(
    _ text: String = "",
    with paddingString: String = " ",
    toFill width: Int,
    alignment: Alignment = .center,
    splitCharacter: Character = "@",
    caps: LineCaps? = nil, /// This is `String` in case of multi-character caps
    hasSpaceAroundText: Bool = true
  ) -> String {
    
    /// If there is no split character present in the provided `text`, this will simply return a
    /// `[String.SubSequence]` with the full text.
    ///
    /// I could consider changing `omittingEmptySubsequences: true` to `false`,
    /// if I needed support for allowing `@` splits at the very beginning or end of the line.
    /// For now, I am setting it to true, so that splits that result in empty chunks are
    /// not counted toward the width count or padding lengths.
    ///
    /// For example, below I've placed an `@` at the beginning:
    ///
    /// ```
    /// TextCore.padLine(
    /// "@Two splits@Split at beggining",
    /// with: "░",
    /// toFill: 42
    /// )
    /// ```
    /// Content: `["", "Two splits", "Split at beggining"]`
    ///
    /// Result: `^░░░░░^Two splitsx░░░░░^Split at beggining`
    /// Or, result: `Two splits^░░░░░░░░░░^Split at beggining`
    ///
    let splitTextChunk: [String.SubSequence] = text.split(separator: splitCharacter, omittingEmptySubsequences: true)
    
    /// This is the number of characters in the text content only. This will be added
    /// to the total count, including caps/padding, to compare against the
    /// `toFill width: Int` parameter.
    ///
    ///
    let contentWidth: Int = splitTextChunk.reduce(0) { accumulatingResult, nextValue in
      accumulatingResult + nextValue.count
    }
    
    let contentIsSplit: Bool = text.contains(splitCharacter)
    
    /// Cap content, space and width
    ///
    var finalCaps: StringCaps = ("", "")
    var capsSpaceCount: (leading: Int, trailing: Int) = (0, 0)
    
    /// Building not only the cap glyphs themselves, but also the spaces if applicable
    ///
    if let caps = caps {
      
      let capSpace = (caps.hasExtraSpaces ? "_" : "")
      
      let leading = caps.leading + capSpace
      let trailing = capSpace + caps.trailing
      
      finalCaps = (leading, trailing)
    }
    
    capsSpaceCount = (finalCaps.leading.count, finalCaps.trailing.count)
    
    
    /// Text space and width
    ///
    /// This will be based heavily on the number of splits. Let's write this out.
    ///
    /// Without adjustment, there will be 2x spaces per split (provided of course
    /// the `hasSpaceAroundText` option is true).
    ///
    /// If a split happens right at the end, or right at the beginning (and I also need
    /// to take into account edge cases like two splits in a row `@@`, which is invalid),
    /// then the leading or trailing space should be removed.
    ///
    /// We subtract `1` below, so we get an accurate count of the split characters
    /// used. For instance, if the user splits the text in `3` places, as in the example
    /// below, we actually get `4` components.
    ///
    /// `"@Here is some@ text to@ split"`
    /// `["", "Here is some", " text to", " split"]`
    ///
    
    /// Test spacing is calculated differently based on whether there are splits in
    /// the text, or not.
    ///
    
    let textExtraSpaceCharacter: String = hasSpaceAroundText ? "^" : ""
    var textExtraSpace: StringCaps = ("", "")
    var textSpaceCount: (leading: Int, trailing: Int) = (0, 0)
    
    
    let splitCount: Int = contentIsSplit ? splitTextChunk.count - 1 : 0
    let splitSpaces: Int = max(0, splitCount * 2)

    
    if contentIsSplit {
      
      textExtraSpace = (textExtraSpaceCharacter, textExtraSpaceCharacter)
      
      
    } else {
      
      switch alignment {
        case .leading:
          textExtraSpace = ("", textExtraSpaceCharacter)
          
        case .trailing:
          textExtraSpace = (textExtraSpaceCharacter, "")
          
        default: // .center
          textExtraSpace = (textExtraSpaceCharacter, textExtraSpaceCharacter)
      }
      
    }

    textSpaceCount = (textExtraSpace.leading.count + splitSpaces, textExtraSpace.trailing.count + splitSpaces)
    
    
    let finalContentWidth = contentWidth
    + capsSpaceCount.leading + capsSpaceCount.trailing
    + textSpaceCount.leading + textSpaceCount.trailing
    
    
    /// Calculates the space left after accounting for all the text content, caps, and
    /// padding — and ensures the value does not fall below zero.
    ///
    let availableSpace = max(0, width - finalContentWidth)
    
    
    
    

    /// This condition applies when there was no split character found in the text,
    /// so the `alignment` argument is used to determine where the padding
    /// should be placed.
    ///
    if splitTextChunk.count <= 1 {
      
      let (leftPadding, rightPadding) = TextCore.distributePadding(for: alignment, padding: availableSpace)
      
      let result = finalCaps.leading
      /// The first lot of padding
      + String(repeating: paddingString, count: leftPadding)
      + textExtraSpace.leading + text + textExtraSpace.trailing
      /// The second lot of padding
      + String(repeating: paddingString, count: rightPadding)
      + finalCaps.trailing
      
      
      
      
      return result
      
    } else {
      
      /// There *was* a split character provided.
      ///
      /// `components.count - 1` gives us the total number of gaps between
      /// components — always one less than the number of components.
      ///
      
//      var hasLeadingSplit: Bool = false
//      var hasTrailingSplit: Bool = false
      
      
      let paddingPerSlice: Int = availableSpace / (splitTextChunk.count - 1)
      
      /// Suppose we have the string `Hello@World@Swift` and 10 available spaces.
      ///
      /// - `components` would be `["Hello", "World", "Swift"]`
      /// - `components.count` is 3
      /// - `components.count - 1` is 2 (number of gaps)
      ///
      /// Now, let's calculate:
      ///
      /// 1. `spacesPerSlice = 10 / 2 = 5`
      /// This means we can put 5 spaces between each component.
      ///
      /// 2. `extraSpaces = 10 % 2 = 0`
      /// There are no extra spaces left over.
      ///
      /// The result would be: `Hello     World     Swift`
      ///
      /// Let's look at another example with 11 available spaces:
      ///
      /// 1. `spacesPerSlice = 11 / 2 = 5`
      /// We can still put 5 spaces between each component.
      ///
      /// 2. `extraSpaces = 11 % 2 = 1`
      /// We have 1 extra space left over.
      ///
      /// In this case, we'd distribute the extra space in the first gap:
      /// `Hello      World     Swift`
      ///
      /// This approach ensures that we use all available space and distribute it as evenly as possible between components.
      ///
      let leftoverPadding = availableSpace % (splitTextChunk.count - 1)
      
      var result = finalCaps.leading
      
      /// Enumerates the components. More than one split character is supported.
      ///
      /// I find it difficult to visualise loops, so here is an example:
      ///
      /// `"@Here is some@ text to@ split"`
      ///
      /// Output:
      /// ```
      /// Index: 0 : Content:
      /// Index: 1 : Content: Here is some
      /// Index: 2 : Content:  text to
      /// Index: 3 : Content:  split
      /// ```
      ///
      for (index, textContent) in splitTextChunk.enumerated() {
        
        print("Index: \(index) : Content: \(textContent)")
        
        result += textContent
        
        /// The below (`if index < components.count - 1`) makes sure the current
        /// component is not the *last* one in the array of components. We use this to determine
        /// whether to add padding after the current component.
        ///
        /// We don't want to add padding after the last component, as that would put unnecessary
        /// spacing at the end of the string.
        ///
        /// Let's break it down further:
        ///
        /// - `components.count` gives us the total number of components.
        /// - `components.count - 1` is the index of the last component.
        /// - `index < components.count - 1` is true for all components except the last one.
        ///
        /// For example, if we have a string "Hello@World" split by "@":
        ///
        /// - `components` would be `["Hello", "World"]`
        /// - `components.count` would be 2
        /// - `components.count - 1` would be 1
        ///
        /// So, when we iterate:
        /// - For "Hello" `(index 0): 0 < 1` is true, so we add padding after it.
        /// - For "World" `(index 1): 1 < 1` is false, so we don't add padding after it.
        ///
        /// This ensures that we add padding between components but not after the final component,
        /// which helps maintain the correct overall width and appearance of the padded line.
        ///
        /// Note: I still wasn't getting this, until I realised that
        ///
        if index < splitTextChunk.count - 1 {
          
          let padding = paddingPerSlice + (index < leftoverPadding ? 1 : 0)
          
          /// This is where the padding is actually added, for each split
          ///
          result += textExtraSpace.leading
          + String(repeating: paddingString, count: padding)
          + textExtraSpace.trailing
          
          
          
        }

      }
      
      result += finalCaps.trailing
      
      
      
      let metrics: String = """
      
      
      
      ---
      
      Content: \(splitTextChunk)
      Chunk count: \(splitTextChunk.count)
      Text spaces: \(textSpaceCount)
      
      How many splits? \(splitCount)
      
      Content width: \(contentWidth)
      Caps: \(finalCaps), and their width: \(capsSpaceCount)
      
      Provided space: \(width)
      Total content width inc. spaces & caps: \(finalContentWidth)
      
      Remaining available width, to be padded out: \(availableSpace)
      ---
      
      
      
      
      
      """
      
      print(!contentIsSplit ? metrics : "")
      
      
      
      return result
    }
    
    
  } // END pad line
  
  static func distributePadding(for alignment: Alignment, padding: Int) -> (left: Int, right: Int) {
    
    switch alignment {
      case .leading:
        return (0, padding)
      case .trailing:
        return (padding, 0)
      default: // .center
        let left = max(0, padding / 2)
        return (left, max(0, padding - left))
    }
  }
  
}

