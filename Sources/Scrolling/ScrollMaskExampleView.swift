//
//  SwiftUIView.swift
//
//
//  Created by Dave Coleman on 11/7/2024.
//

import SwiftUI
import BaseHelpers

struct FadingScrollView<Content: View>: View {
  let content: Content
  @State private var fadeTopOpacity: CGFloat = 0
  @State private var fadeBottomOpacity: CGFloat = 0
  
  @State private var scrollOffset: CGFloat = .zero
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    ScrollView {
//      GeometryReader { proxy in
//        let offset = proxy.frame(in: .named("scroll")).minY
//        Color.clear.preference(
//          key: ScrollOffsetPreferenceKey.self,
//          value: offset
//        )
//      }
//      .frame(height: 0)
      
      content
        .readFrame(coordinateSpaceName: "scroll") { point in
          self.scrollOffset = point.y
        }
        
    }
    .coordinateSpace(name: "scroll")
//    .mask(
//      VStack(spacing: 0) {
//        LinearGradient(
//          gradient: Gradient(stops: [
//            .init(color: .black.opacity(fadeTopOpacity), location: 0),
//            .init(color: .black, location: 0.15)
//          ]),
//          startPoint: .top,
//          endPoint: .bottom
//        )
//        LinearGradient(
//          gradient: Gradient(stops: [
//            .init(color: .black, location: 0.85),
//            .init(color: .black.opacity(fadeBottomOpacity), location: 1)
//          ]),
//          startPoint: .top,
//          endPoint: .bottom
//        )
//      }
//    )
    
//    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
//      // Here you can implement your gradual fade logic based on offset
//      let fadeThreshold: CGFloat = 50
//      
//      withAnimation {
//        fadeTopOpacity = offset < 0 ?
//        min(1, abs(offset) / fadeThreshold) : 0
//        
//        fadeBottomOpacity = offset > 0 ?
//        min(1, abs(offset) / fadeThreshold) : 0
//      }
//    } // END pref change
    .overlay(alignment: .topLeading) {
      Text(scrollOffset.description)
    }
  }
}
//
//struct ScrollOffsetPreferenceKey: PreferenceKey {
//  static var defaultValue: CGFloat = 0
//  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//    value = nextValue()
//  }
//}


//struct ScrollMaskExample: View {
//  
//  var axes: [Edge] = [.top]
//  var maskModes: [MaskMode] = [.overlay(), .mask]
//  var lengths: [CGFloat] = [90, 220]
//  
//  //  @State private var offSet: CGFloat = .zero
//  
//  var body: some View {
//    
//    let columns = [
//      GridItem(.flexible()),
//      GridItem(.flexible())
//    ]
//    
//    LazyVGrid(columns: columns, spacing: 30) {
//      ForEach(MaskMode.allCases) { mode in
//        ForEach(lengths, id: \.self) { length in
//          ForEach(axes, id: \.self) { edge in
//            VStack {
//              
//              ForEach(1..<5) { item in
//                Text("\(mode.name), Edge: \(edge.name), Length: \(length)")
//                  .frame(maxWidth: .infinity, maxHeight: .infinity)
//              }
//            }
//
//            .scrollWithOffset(
//              maskMode: mode,
//              edge: edge,
//              maskLength: length
//            )
//            
//            .frame(width: 180, height: 300)
//            .scrollIndicators(.hidden)
//            .background(.orange.opacity(0.1))
//            //                .scrollMask(
//            //                  offset:
//            //                    maskMode: .overlay,
//            //                    edge: edge,
//            //                    length: 60
//            //                )
//            .border(Color.purple.opacity(0.2))
//            
//          } // END axes loop
//        } // END lengths loop
//      } // END mask mode loop
//    } // END lazy grid
//    
//  }
//}

#if DEBUG


#Preview {
  FadingScrollView {
    ForEach(0..<30) { number in
      Text("Hello")
        .padding()
    }
  }
    .frame(maxHeight: .infinity)
    .background(.green.opacity(0.1))
#if os(macOS)
    .frame(width: 600, height: 700)
#endif
}

#endif
