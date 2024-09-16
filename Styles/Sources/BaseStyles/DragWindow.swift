//
//  File.swift
//  
//
//  Created by Dave Coleman on 8/6/2024.
//

#if os(macOS)

import Foundation
import SwiftUI


public extension View {
    func dragWindow(isOn: Bool = true) -> some View {
        self.overlay {
            if isOn {
                DragWindowView()
            }
        }
    }
}

public struct DragWindowView: View {
    
    public var body: some View {
        Color.clear
            .overlay( DragWindowViewNSRep() )
    }
}




fileprivate struct DragWindowViewNSRep: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        return DragWindowViewNSView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}

fileprivate class DragWindowViewNSView: NSView {
    override public func mouseDown(with event: NSEvent) {
        window?.performDrag(with: event)
    }
}

#endif
