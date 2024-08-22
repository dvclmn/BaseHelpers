//
//  Examples.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

struct BoxPrintView: View {
  
  @State private var consoleOutput = ConsoleOutput(config: .init())
  
  var body: some View {
    
    VStack(spacing: 30) {
      
      VStack{
        Text(consoleOutput.drawBox(
          header: "It's a header",
          content: TestStrings.paragraphs[1].preview(300)
        ))
      }

      .textSelection(.enabled)
    }
    .monospaced()
    .padding(40)
    .frame(width: 600, height: 300)
    .background(.black.opacity(0.6))
    
  }
}

extension BoxPrintView {
  
}


#Preview {
  BoxPrintView()
}

