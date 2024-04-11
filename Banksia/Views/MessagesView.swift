////
////  MessagesView.swift
////  Banksia
////
////  Created by Dave Coleman on 20/11/2023.
////
//
//import SwiftUI
//import SwiftData
//
//struct MessagesView: View {
//    @Environment(BanksiaHandler.self) private var bk
//    @Environment(\.modelContext) private var modelContext
//        
//    @Query private var conversations: [Conversation]
//    
//    init(filter: Predicate<Conversation>? = nil) {
//        
//        if let filter = filter {
//            _conversations = Query(filter: filter)
//        } else {
//            _conversations = Query()
//        }
//    }
//    
//    var body: some View {
//
//
//    
//
//}
//
//#Preview {
//    ModelContainerPreview(ModelContainer.sample) {
//        ContentView()
//            .environment(BanksiaHandler())
//            .frame(width: 700, height: 700)
//    }
//}
