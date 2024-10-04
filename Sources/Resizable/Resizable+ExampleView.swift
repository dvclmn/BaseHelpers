//
//  ResizableExampleView.swift
//
//
//  Created by Dave Coleman on 20/6/2024.
//

import SwiftUI
import Foundation

struct ResizableExample: View {
    
    
    @State private var editorContentHeight: CGFloat = 300
    
    @State private var manualModeSidebar: Bool = false
    @State private var manualModeToolbar: Bool = false
    @State private var manualModeInspector: Bool = false
    @State private var manualModeEditor: Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            
            HStack(spacing: 0) {
                //
                VStack {
                    VStack(spacing: 20) {
                        ForEach(1...5, id: \.self) { item in
                            Text(item.description)
                                .frame(maxWidth: .infinity, maxHeight: 20)
                        }
                    }
                    .padding()
                    Spacer()
                    
                } // END sidebar vstack
                
                .background(.green.opacity(0.2))
                .resizable(
                    //                    contentLength: sidebarDynamicWidth,
                    isManualMode: $manualModeSidebar,
                    edge: .trailing,
                    isShowingFrames: true,
                    lengthMin: 80,
                    lengthMax: 300)

            } // END hstack
          
          VStack {
            HStack(spacing: 20) {
              ForEach(1...5, id: \.self) { item in
                Text(item.description)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              }
            }
          } // END sidebar vstack
          .background(.purple.opacity(0.2))
          .resizable(
            //                contentLength: toolbarDynamicHeight,
            isManualMode: $manualModeToolbar,
            edge: .top,
            isShowingFrames: true,
            lengthMin: 40,
            lengthMax: 200)
          
          
            
        } // END main vstack
    }
}
#Preview {
    ResizableExample()
        .frame(width: 600, height: 700)
        .background(.black.opacity(0.6))
}
