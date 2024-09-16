//
//  PadLineTests.swift
//  TextCore
//
//  Created by Dave Coleman on 30/8/2024.
//

import Foundation

extension TextCoreExampleView {
  
  func padLineString(width: Int, cap: String) -> AttributedString {
    
    var output = AttributedString()
    
    output.appendString(TextCore.widthCounter(self.width, style: .full).string, addsLineBreak: false)
    
    output.appendString("# LineCaps, with spacing", addsLineBreak: false)
    
    output.appendString(
      TextCore.padLine(
        "Cap & text padding",
        with: "░",
        toFill: width,
        alignment: .leading,
        caps: LineCaps(cap, cap, hasExtraSpaces: true),
        hasSpaceAroundText: true
      ), addsLineBreak: false
    )
    
    output.appendString(
      TextCore.padLine(
        "Has text-pad, no cap-pad",
        with: "░",
        toFill: width,
        alignment: .center,
        caps: LineCaps(cap, cap, hasExtraSpaces: true),
        hasSpaceAroundText: true
      ), addsLineBreak: false
    )
    
    output.appendString(
      TextCore.padLine(
        "No text-pad. Has cap-pad",
        with: "░",
        toFill: width,
        alignment: .trailing,
        caps: LineCaps(cap, cap),
        hasSpaceAroundText: true
      ), addsLineBreak: false
    )
    
    output.addLineBreak()
    
    output.appendString("# No LineCaps, with spacing", addsLineBreak: false)
    
    output.appendString(
      TextCore.padLine(
        "Text padding center",
        with: "░",
        toFill: width,
        alignment: .leading,
        hasSpaceAroundText: true
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "Text padding center",
        with: "░",
        toFill: width,
        alignment: .center,
        hasSpaceAroundText: true
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "Text padding center",
        with: "░",
        toFill: width,
        alignment: .trailing,
        hasSpaceAroundText: true
      ), addsLineBreak: false
    )
    
    
    output.addLineBreak()
    
    output.appendString("# Splits [✓], spaces [✓], caps [ ]", addsLineBreak: false)
    
    output.appendString(
      TextCore.padLine(
        "Split ->@<- Split",
        with: "░",
        toFill: width
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "An icon@Some nice text",
        with: "░",
        toFill: width
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "@Two splits@Split at begin@ning",
        with: "░",
        toFill: width
      ), addsLineBreak: false
    )
    
    output.addLineBreak()
    output.appendString("# Splits [✓], spaces [ ], caps [ ]", addsLineBreak: false)
    
    output.appendString(
      TextCore.padLine(
        "Split ->@<- Split",
        with: "░",
        toFill: width,
        hasSpaceAroundText: false
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "An icon@Some nice text",
        with: "░",
        toFill: width,
        hasSpaceAroundText: false
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "@Two splits@Split at begin@ning",
        with: "░",
        toFill: width,
        hasSpaceAroundText: false
      ), addsLineBreak: false
    )
    
    
    output.addLineBreak()
    output.appendString("# Splits [✓], spaces [✓], caps [✓]", addsLineBreak: false)
    
    output.appendString(
      TextCore.padLine(
        "Split ->@<- Split",
        with: "░",
        toFill: width,
        caps: LineCaps(cap, cap)
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "An iconSome ni@ce text@",
        with: "░",
        toFill: width,
        caps: LineCaps(cap, cap)
      ), addsLineBreak: false
    )
    output.appendString(
      TextCore.padLine(
        "@Here is some@ text to@ split",
        with: "░",
        toFill: width,
        caps: LineCaps(cap, cap)
      ), addsLineBreak: false
    )
    
    return output
  }
  
}
