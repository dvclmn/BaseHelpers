//
//  SwiftUIView.swift
//  
//
//  Created by Dave Coleman on 11/8/2024.
//

import SwiftUI

//struct GrainientExample: View {
//    var body: some View {
//        Text("Hello, World!")
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .grainient(seed: 98365)
//    }
//}
//
//#Preview {
//  GrainientExample()
//}


struct GrainientBrowser: View {
  
  var body: some View {
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    LazyVGrid(columns: columns) {
      ForEach(GrainientPreset.allPresets) { preset in
        Color.clear
          .aspectRatio(4.4, contentMode: .fit)
          .grainient(seed: preset.seed)
          .clipShape(.rect(cornerRadius: 10))
          .overlay {
            Text(preset.name)
              .foregroundStyle(.secondary)
              .fontWeight(.medium)
          }
      }
    }
      .padding(40)
      .frame(width: 800, height: 800)
      .background(.black.opacity(0.6))
    
  }
}
#if DEBUG
#Preview {
  GrainientBrowser()
}
#endif

