//
//  SwiftUIView.swift
//
//
//  Created by Dave Coleman on 11/7/2024.
//

import SwiftUI


struct ScrollMaskExample: View {
    
    var fourAxes: [Edge] = [.top, .bottom, .leading, .trailing]
    
    @State private var isOn: Bool = true
    
    var body: some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        LazyVGrid(columns: columns, spacing: 60) {
            ForEach(fourAxes, id: \.self) { edge in
                ScrollView {
                    VStack {
                        ForEach(1..<5) { item in
                            Text(edge.name)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .border(Color.green.opacity(0.2))
                .frame(width: 180, height: 300)
                .scrollIndicators(.hidden)
                .background(.orange.opacity(0.1))
                .scrollMask(
                    isOn,
                    maskMode: .overlay,
                    edge: edge,
                    length: 60
                )
                .border(Color.purple.opacity(0.2))
                
            }
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

