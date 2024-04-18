//
//  MapTest.swift
//  Banksia
//
//  Created by Dave Coleman on 18/4/2024.
//

import SwiftUI

import SwiftUI
import Foundation

class ConversationTest: Identifiable {
    var id = UUID()
    var messages: [MessageTest]? = []
    
    init(id: UUID = UUID(), messages: [MessageTest]? = []) {
        self.id = id
        self.messages = messages
    }
    
    static let conversation = ConversationTest(messages: [
        MessageTest.prompt01,
        MessageTest.response01,
        MessageTest.prompt02,
        MessageTest.response02,
        MessageTest.prompt03,
        MessageTest.response03,
        MessageTest.prompt04,
        MessageTest.response04,
    ])
}

class MessageTest: Identifiable {
    var id = UUID()
    var timestamp = Date.now
    var content: String = ""
    var conversation: Conversation? = nil
    
    init(id: UUID = UUID(), timestamp: Date = Date.now, content: String, conversation: Conversation? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.content = content
        self.conversation = conversation
    }
    
    static let prompt01 = MessageTest(
        timestamp: Date().addingTimeInterval(-900),
        content: "Prompt 1")
    static let response01 = MessageTest(
        timestamp: Date().addingTimeInterval(-800),
        content: "Response 1")
    
    static let prompt02 = MessageTest(
        timestamp: Date().addingTimeInterval(-700),
        content: "Prompt 2")
    static let response02 = MessageTest(
        timestamp: Date().addingTimeInterval(-600),
        content: "Response 2")
    
    static let prompt03 = MessageTest(
        timestamp: Date().addingTimeInterval(-500),
        content: "Prompt 3")
    static let response03 = MessageTest(
        timestamp: Date().addingTimeInterval(-400),
        content: "Response 3")
    
    static let prompt04 = MessageTest(
        timestamp: Date().addingTimeInterval(-300),
        content: "Prompt 4")
    
    static let response04 = MessageTest(
        timestamp: Date().addingTimeInterval(-200),
        content: "Response 4")
}

struct MapTest: View {
    
    let conversation = ConversationTest.conversation
    
    let date = Date.now
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                Text(messageHistory() ?? "")
                    .font(.system(size: 12))
            }
            
//            if let messages = conversation.messages {
//                ForEach(messages) { message in
//                    HStack {
//                        Text(message.content)
//                        Spacer()
//                        Text(message.timestamp.description)
//                    }
//                        .padding(.bottom, 8)
//                        .monospaced()
//                }
//                
//            } // END check
            
        }
    }
    
    private func messageHistory() -> String? {
        guard let messages = conversation.messages else {
            return nil
        }
        
        let sortedMessages: [MessageTest] = messages.sorted(by: { $0.timestamp < $1.timestamp })
        
        let maxMessageContextCount: Int = 5
        
        let historicalMessages: [MessageTest] = sortedMessages.suffix(maxMessageContextCount)
        
        let historyFormatted: String = historicalMessages.map {
            formatMessageForGPT($0)
        }.joined(separator: "\n\n")
        
     
        return historyFormatted
    }
    
    func formatMessageForGPT(_ message: MessageTest) -> String {
        print("|--- formatMessageForGPT --->")
        
        let messageID: String = message.id.description
        
        let messageBegin: String = "\n# Message \n"
        let timeStamp: String = "*Timestamp:* \(message.timestamp)"
        
        let content: String = "*Message:*\n\(message.content)"
        let messageEnd: String = "\n --- END Message ID: ---"
        
        let formattedMessage: String = """
        \(messageBegin)
        \(timeStamp)
        \(content)
        \(messageEnd)
        """
        print(">--- END formatMessageForGPT ---|\n")
        return formattedMessage
    }
}

#Preview {
    MapTest()
        .padding()
        .frame(width: 400, height: 760)
}
