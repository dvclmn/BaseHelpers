//
//  Examples.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

struct BoxPrintView: View {
  
  @State private var displayText: AttributedString = AttributedString("")
  @State private var output: ConsoleOutput
  
  init() {
    _output = State(initialValue: ConsoleOutput(
      header: "TestStrings.paragraphs[0]",
      content: TestStrings.paragraphs[1],
      text: { _ in }  // We'll update this in onAppear
    ))
  }
  
  var body: some View {
    
    VStack(spacing: 30) {
      
      VStack{
        Text(displayText)
      }

      .textSelection(.enabled)
    }
    .onAppear {
      // Update the text closure here
      output.text = { newText in
        displayText = newText
      }
    }
    
    .monospaced()
    .padding(40)
    .frame(width: 600, height: 300)
    .background(.black.opacity(0.6))
    
  }
}

extension BoxPrintView {
//  var string: AttributedString {
//    var output: AttributedString = ""
//    ConsoleOutput(
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

