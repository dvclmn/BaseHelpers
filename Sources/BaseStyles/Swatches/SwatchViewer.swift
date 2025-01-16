//
//  SwiftUIView.swift
//
//
//  Created by Dave Coleman on 11/8/2024.
//

//import SwiftUI
//
//struct SwatchViewer: View {
//  
//  private let swatchSize: Double = 40
//  
//  private let columns = Array(repeating: GridItem(.flexible(), spacing: 22), count: 4)
//  
//  var body: some View {
//    
//    
//    LazyVGrid(columns: columns, spacing: 20) {
//      ForEach(Swatch.allCases) { swatch in
//        VStack {
//          RoundedRectangle(cornerRadius: 10)
//            .fill(swatch.colour)
//            .frame(width: swatchSize, height: swatchSize)
//          
//          Text(swatch.rawValue)
//            .font(.caption)
//            .foregroundStyle(.secondary)
//        }
//        
//      }
//    } // END lazy grid
//#if os(macOS)
//    .frame(width: 600, height: 700)
//    
//#else
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//#endif
//    
//    .background(.black.opacity(0.06))
//    .ignoresSafeArea()
//    
//  }
//}
//
//#Preview {
//  SwatchViewer()
//}
//
