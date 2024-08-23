//
//  Examples.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

struct BoxPrintView: View {
  
  let box01 = SwiftBox(
    header: TestStrings.paragraphs[0],
    content: TestStrings.paragraphs[1],
    config: Config(
      width: 46,
      contentLineLimit: 8,
      showsMetrics: true
    )
  )
  
  let box02 = SwiftBox(
    header: TestStrings.conversationTitles[1],
    content: TestStrings.paragraphs[3],
    config: Config(
      width: 20,
      contentLineLimit: 8,
      showsMetrics: true
    )
  )
  
  var body: some View {
    
    VStack(spacing: 30) {
      
      VStack(spacing: 20) {
        Text(box01.attributedString)
        Text(box02.attributedString)
      }
      .textSelection(.enabled)
    }
    
    .monospaced()
    .padding(40)
    .frame(width: 600, height: 700)
    .background(.black.opacity(0.6))
    
  }
}

extension BoxPrintView {
  //  var string: AttributedString {
  //    var output: AttributedString = ""
  //    SwiftBox(
  //      header: ,
  //      content: ,
  //      config: .default
  //    ) { text in
  //      output = text
  //    }
  //
  //    return output
  //  }
}


#Preview {
  BoxPrintView()
}

