//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation


extension NSTextLineFragment {
   
   /// Returns a text range inside privided textLayoutFragment.
   ///
   /// Returned range is relative to the document range origin.
   /// - Parameter textLayoutFragment: Text layout fragment
   /// - Returns: Text range or nil
   public func textRange(in textLayoutFragment: NSTextLayoutFragment) -> NSTextRange? {
      
      guard let textContentManager = textLayoutFragment.textLayoutManager?.textContentManager else {
         assertionFailure()
         return nil
      }
      
      return NSTextRange(
         location: textContentManager.location(textLayoutFragment.rangeInElement.location, offsetBy: characterRange.location)!,
         end: textContentManager.location(textLayoutFragment.rangeInElement.location, offsetBy: characterRange.location + characterRange.length)
      )
   }
   
   
   /// Whether the line fragment is for the extra line fragment at the end of a document.
   ///
   /// The layout manager uses the extra line fragment when the last character in a document causes a line or paragraph break. This extra line fragment has no corresponding glyph.
   public var isExtraLineFragment: Bool {
      // textLineFragment.characterRange.isEmpty the extra line fragment at the end of a document.
      characterRange.isEmpty
   }
   
}
