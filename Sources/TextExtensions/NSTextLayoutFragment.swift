//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation

// Credit: https://github.com/krzyzanowskim/STTextKitPlus/blob/main/Sources/STTextKitPlus/NSTextLayoutFragment.swift
extension NSTextLayoutFragment {
   
   public func textLineFragment(at location: NSTextLocation, in textContentManager: NSTextContentManager? = nil) -> NSTextLineFragment? {
      guard let textContentManager = textContentManager ?? textLayoutManager?.textContentManager else {
         assertionFailure()
         return nil
      }
      
      let searchNSLocation = NSRange(location, in: textContentManager).location
      let fragmentLocation = NSRange(rangeInElement.location, in: textContentManager).location
      return textLineFragments.first { lineFragment in
         let absoluteLineRange = NSRange(location: lineFragment.characterRange.location + fragmentLocation, length: lineFragment.characterRange.length)
         return absoluteLineRange.contains(searchNSLocation)
      }
   }
   
   public func textLineFragment(at location: CGPoint, in textContentManager: NSTextContentManager? = nil) -> NSTextLineFragment? {
      textLineFragments.first { lineFragment in
         CGRect(origin: layoutFragmentFrame.origin, size: lineFragment.typographicBounds.size).contains(location)
      }
   }
}
