//
//  Examples.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

struct BoxPrintView: View {
  
  @State private var output: ConsoleOutput = ConsoleOutput(
    header: TestStrings.paragraphs[0],
    content: TestStrings.paragraphs[1],
    config: Config(width: 40, contentLineLimit: 10)
  )
  
  var body: some View {
    
    VStack(spacing: 30) {
      
      VStack{
        Text(output.attributedString)
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

