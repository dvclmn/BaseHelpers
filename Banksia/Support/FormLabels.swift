//
//  FormLabel.swift
//  Eucalypt
//
//  Created by Dave Coleman on 26/3/2024.
//

import Foundation
import SwiftUI


struct FormLabel<Content: View>: View {
    
    let pref = Preferences()
    
    let label: String
    let icon: String
    let message: String?
    let content: () -> Content
    
    init(
        label: String,
        icon: String,
        message: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.icon = icon
        self.message = message
        self.content = content
    }
    
    var body: some View {
        LabeledContent {
#if os(macOS)
            HStack(spacing: 10) {
                content()
                    .labelsHidden()
                    .toggleStyle(.switch)
            } // END hstack
#else
            
            content()
#endif
            
        } label: {
            Label {
                Text(label)
            } icon: {
                Image(systemName: icon)
                    .frame(width: Styles.iconWidth)
                    .foregroundStyle(.secondary.opacity(0.9))
                    .fontWeight(.medium)
            }
            if let message = message {
                Text(message)
                    .padding(.top,6)
                    .lineLimit(4)
                
            }
            
        } // END label
    }
    
    
}

#Preview {
    Form {
        FormLabel(
            label: "Hello",
            icon: Icons.list.icon,
            message: "It's a message") {
                Button("Cool") {
                    
                }
            }
    }
#if os(macOS)
            .padding(50)
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
//        .frame(width: 400, height: 700)

#endif
}
