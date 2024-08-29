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
                edge: .bottom,
                isShowingFrames: true,
                lengthMin: 40,
                lengthMax: 200)
            
            
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
                //
                //
                //                VStack {
                //                    Text("Messages")
                //                }
                //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                .background(.red.opacity(0.2))
                //
                //                .overlay(alignment: .bottom) {
                //
                //                    ScrollView {
                //                        VStack {
                //                            ForEach(1...10, id: \.self) { item in
                //                                Text("Random")
                //                            }
                //                        }
                //                        .frame(maxWidth: .infinity)
                //                        .opacity(0.2)
                //                    }
                //                    .background(.teal.opacity(0.4))
                //                    .resizable(
                //                        contentLength: editorContentHeight,
                //                        isManualMode: $manualModeEditor,
                //                        edge: .top,
                //                        isShowingFrames: true,
                //                        lengthMin: 80,
                //                        lengthMax: 400)
                //
                //                } // END overlay
                //
                //
                //                VStack {
                //
                //                    Text("Inspector")
                //                    VStack(spacing: 20) {
                //                        ForEach(1...5, id: \.self) { item in
                //                            Text(item.description)
                //                                .frame(maxWidth: .infinity, maxHeight: 20)
                //                        }
                //                    }
                //                    .padding()
                //                    Spacer()
                //
                //                } // END sidebar vstack
                //
                //                .background(.orange.opacity(0.2))
                //                .resizable(
                //                    //                    contentLength: inspectorDynamicHeight,
                //                    isManualMode: $manualModeInspector,
                //                    edge: .leading,
                //                    isShowingFrames: true,
                //                    lengthMin: 80,
                //                    lengthMax: 300)
                //
                //
            } // END hstack
            
        } // END main vstack
    }
}
#Preview {
    ResizableExample()
        .frame(width: 600, height: 700)
        .background(.black.opacity(0.6))
}
