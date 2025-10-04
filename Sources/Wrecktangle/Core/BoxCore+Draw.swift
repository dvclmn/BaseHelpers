//
//  BoxHandler.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation
import SwiftUI
import BaseHelpers


public extension BoxCore {

  internal func drawBox() -> AttributedString {
    
    /// We start off with a fresh, blank attr. string. The 'build process' is based
    /// on concatenation, added section-by-section, starting from the top.
    var output = AttributedString()
    
    /// Add a width counter, according to user's preference ()
    output += TextCore.widthCounter(boxWidth, style: self.config.metrics.widthCounter)

    
    /// Box roof
    
//    let shadowLine = line(.shadow)
//    output.appendString(shadowLine, addsLineBreak: true)
    
    let top = line(.top)
    output.appendString(top, addsLineBreak: true)
    
    /// Header
    if let headerText = self.header {
      
      let headerLines: [String] = headerText.reflowText(
        width: widthLeftForText,
        maxLines: config.headerLineLimit,
        paddingWidth: self.config.theme.padding,
        paddingCharacter: invisibleIfNeeded(.space),
        wrappingOption: self.config.wordWrapStrategy
      )
      
      for headerLine in headerLines {
        let boxLine = line(.text(content: headerLine, lineLimit: config.headerLineLimit))
        output.appendString(boxLine, addsLineBreak: true)
      }
    }
    
    /// Divider
    let divider = line(.divider)
    output.appendString(divider, addsLineBreak: true)
    
    
    /// Content

    let contentLines: [String] = self.content.reflowText(
        width: widthLeftForText,
        maxLines: config.contentLineLimit,
        paddingWidth: self.config.theme.padding,
        paddingCharacter: invisibleIfNeeded(.space),
        wrappingOption: self.config.wordWrapStrategy
      )
      
      for contentLine in contentLines {
        let boxLine = line(.text(content: contentLine, lineLimit: config.contentLineLimit))
        output.appendString(boxLine, addsLineBreak: true)
      }

    
    /// This could be made conditional on whether the theme's `GlyphSet`
    /// requires it, but this ensures that if there's an alternating frame part,
    /// the number of lines won't create alignment/joining issues
    ///
    //    if !lineCount.isEven {
    //      output += self.constructBoxLine(" ", lineType: .content)
    //    }
    
    
    /// Bottom
    let bottom = line(.bottom)
    output.appendString(bottom, addsLineBreak: true)

    return output
  }

  

}
