//
//  Examples.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI
import BaseHelpers

struct BoxExampleView: View {
  
  #if os(macOS)
  let boxWidth: Int = 38
  #else
  let boxWidth: Int = 27
  #endif
  
  var body: some View {
    
    VStack(spacing: 14) {
      
      Text(box01.attributedString)
//      Text(box02.attributedString)
      
//      HStack {
//        Text(boxSmall01.attributedString)
//        Text(boxSmall02.attributedString)
//      }
    }
    .preferredColorScheme(.dark)
    .textSelection(.enabled)
    .monospaced()
    .environment(\._lineHeightMultiple, 0.84)
    .frame(width: 370, height: 640)
    .background(.black.opacity(0.6))
  }
}

#Preview {
  BoxExampleView()
}

extension BoxExampleView {
  
  
  
  var box01: Box {
    Box(
      header: "I love boxes made of text",
      content: Self.testString,
      width: boxWidth,
      glyphSet: .rounded,
      frameStyle: .double,
      widthCounter: .off
    )
  }
 
  
  static var testString: String {
  """
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
  
  
    ╭──────────────────────────────╮
  //│ ╭──────────────────────────╮ │
  //│ │ At this point I've made  │ │
  //│ │ more commits to my repo  │ │
  //│ │ *renaming* it, than I    │ │
  //│ │ have for actual code.    │ │
  //│ │                          │ │
  //│ ╰──────────────────────────╯ │
  //╰──────────────────────────────╯
  /////////////////////////////////
  
  
  
  At this point I've made 
  more commits to my repo 
  renaming it than I have 
  for actual code. 
    
  """
  }
}
