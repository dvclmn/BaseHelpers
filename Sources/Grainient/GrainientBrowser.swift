//
//  SwiftUIView.swift
//  
//
//  Created by Dave Coleman on 11/8/2024.
//

import SwiftUI

struct GrainientBrowser: View {
  
  var body: some View {
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 4)
    
    LazyVGrid(columns: columns) {
      ForEach(Grainient.allPresets) { preset in
        Color.clear
          .aspectRatio(1.8, contentMode: .fit)
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

