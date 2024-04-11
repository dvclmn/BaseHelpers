//
//  SingleMessageView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData

struct SingleMessageView: View {
    
    var message: Message
    
    var body: some View {
        VStack {
            VStack {
                
                Text(message.content)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding()
                    .id(message.timestamp)
                    .contextMenu {
                        Button {
                            
                        } label: {
                            Label("Delete message", systemImage: Icons.arrowDown)
                        }
                    }
            }
            .frame(maxWidth: 500)
            .background(Color(message.isUser ? .blue : .gray).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: Styles.roundingMedium))
        }
        .font(.system(size: 14))
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SingleMessageView(message: Message.prompt_02)
        .frame(width: 700, height: 700)
    }
}
