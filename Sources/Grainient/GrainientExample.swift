//
//  SwiftUIView.swift
//  
//
//  Created by Dave Coleman on 11/8/2024.
//

import SwiftUI

struct GrainientExample: View {
    var body: some View {
        Text("Hello, World!")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .grainient(seed: 98365)
    }
}

#Preview {
  GrainientExample()
}


struct GrainientBrowser: View {
  
  var body: some View {
    
    Text("Hello")
      .padding(40)
      .frame(width: 600, height: 700)
      .background(.black.opacity(0.6))
    
  }
}
#if DEBUG
#Preview {
  GrainientBrowser()
}
#endif

