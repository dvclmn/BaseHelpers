//
//  ExampleDebugView.swift
//  BaseComponents
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

struct PathDebugExampleView: View {
  
  var body: some View {
    
    VStack {
      
      ShapeDebug {
        
        RoundedRectangle(cornerRadius: 20)
        //        DialogueArrowShape(
        //          cornerRadius: 70,
        //          arrowHeight: 80,
        //          arrowWidth: 180,
        //          arrowPosition: 0.5,
        //          arrowCurveAmount: 0.5
        //        )
      }
      .frame(width: 300, height: 500)
    }
    .padding(40)
    .frame(width: 580, height: 700)
    .background(.black.opacity(0.6))
    
  }
  
}
#if DEBUG
#Preview {
  PathDebugExampleView()
}
#endif
