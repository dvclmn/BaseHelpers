//
//  SwiftUIView.swift
//
//
//  Created by Dave Coleman on 11/7/2024.
//

import SwiftUI


struct ScrollMaskExample: View {
  
  var axes: [Edge] = [.top]
  var maskModes: [MaskMode] = [.overlay(), .mask]
  var lengths: [CGFloat] = [90, 220]
  
  //  @State private var offSet: CGFloat = .zero
  
  var body: some View {
    
    let columns = [
      GridItem(.flexible()),
      GridItem(.flexible())
    ]
    
    LazyVGrid(columns: columns, spacing: 30) {
      ForEach(MaskMode.allCases) { mode in
        ForEach(lengths, id: \.self) { length in
          ForEach(axes, id: \.self) { edge in
            VStack {
              
              ForEach(1..<5) { item in
                Text("\(mode.name), Edge: \(edge.name), Length: \(length)")
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              }
            }

            .scrollWithOffset(
              maskMode: mode,
              edge: edge,
              maskLength: length
            )
            
            .frame(width: 180, height: 300)
            .scrollIndicators(.hidden)
            .background(.orange.opacity(0.1))
            //                .scrollMask(
            //                  offset:
            //                    maskMode: .overlay,
            //                    edge: edge,
            //                    length: 60
            //                )
            .border(Color.purple.opacity(0.2))
            
          } // END axes loop
        } // END lengths loop
      } // END mask mode loop
    } // END lazy grid
    
  }
}

#Preview {
  ScrollMaskExample()
    .frame(maxHeight: .infinity)
    .background(.green.opacity(0.1))
#if os(macOS)
    .frame(width: 600, height: 700)
#endif
}

