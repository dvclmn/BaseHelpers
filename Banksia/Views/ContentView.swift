//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import GeneralUtilities
import Navigation
import GeneralStyles
import Popup
import Sidebar
import Grainient
import Swatches
import Icons
import KeyboardShortcuts

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var closeWindow
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    
    @Query private var conversations: [Conversation]
    
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var popup: PopupHandler
    
    @EnvironmentObject var sidebar: SidebarHandler
    
    var body: some View {
        
        NavigationStack(path: $nav.path) {
            
            DetailView()
            
                .navigationDestination(for: Page.self) { page in
                    DetailView(page: page)
                }
        }
        .frame(
            minWidth: sidebar.contentMinWidth,
            idealWidth: .infinity,
            maxWidth: .infinity,
            minHeight: Styles.minContentHeight,
            maxHeight: .infinity,
            alignment: .trailing
        )
        .readSize { size in
            sidebar.windowSize = size
        }
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
        .ignoresSafeArea()
        .grainient(
            seed: conv.grainientSeed ?? bk.defaultGrainientSeed,
            version: .v1,
            dimming: $bk.uiDimming
        )
        .background(Swatch.slate.colour)
//        .overlay(alignment: .bottomLeading) {
//            if isPreview {
//                HStack {
//                    VStack {
//                        Spacer()
//                        Button {
//                            bk.toggleQuickOpen()
//                        } label: {
//                            Label("Toggle QO", systemImage: Icons.text.icon)
//                        }
//                        .padding(.bottom, bk.editorHeight + 10)
//                    }
//                    Spacer()
//                }
//            }
//        }
        
        
        .onAppear {
            
            KeyboardShortcuts.onKeyUp(for: .summonBanksia) {
                bringAppToForeground()
            }
            
//            #if DEBUG
//            
//                        try? modelContext.delete(model: Conversation.self)
//            
//            #endif
            
            closeWindow.callAsFunction(id: "debug")
            
            if conversations.isEmpty {
                let grainientSeed = GrainientSettings.generateGradientSeed()
                let newConversation = Conversation(grainientSeed: grainientSeed)
                
                modelContext.insert(newConversation)
                
                nav.navigate(to: .conversation(newConversation))
            }
            presentConversation()
            
#if DEBUG
            
            let testName: String = "Test conversation"
            
            if !testConversationExists(testName) {
                let testConversation = Conversation(
                    name: testName,
                    icon: Icons.sport.icon,
                    grainientSeed: GrainientPreset.chalkyBlue.seed
                )
                
                let messages = generateTestMessages()
                
                testConversation.messages = messages
                
                modelContext.insert(testConversation)
                
            }
            
#endif
            
            
        } // END on appear
        
        .task(id: conv.currentRequest) {
            switch conv.currentRequest {
            case .new:
                newConversation()
                conv.currentRequest = .none
                
            case .delete:
                deleteCurrentConversation()
                conv.currentRequest = .none
                
            case .goToPrevious:
                print("Request to navigate to previous conversation")
                conv.currentRequest = .none
                
            case .goToNext:
                print("Request to navigate to next conversation")
                conv.currentRequest = .none
                
            case .toggleSidebar:
                sidebar.toggleSidebar()
                
            case .toggleToolbarExpanded:
                bk.toggleExpanded()
                
            case .toggleDebug:
                bk.isDebugShowing.toggle()
                
            default:
                break
            }
        }
        
        .task(id: nav.path) {
            print("Navigation path changed")
            conv.currentConversationID = fetchCurrentConversation()?.persistentModelID
            nav.updateLastDestination()
        }
        .task(id: bk.isDebugShowing) {
            if bk.isDebugShowing {
                openWindow.callAsFunction(id: "debug")
            } else {
                closeWindow.callAsFunction(id: "debug")
            }
        }
        
        
        
    }
}

extension ContentView {
    
    private func bringAppToForeground() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    func presentConversation() {
        if let lastDestinationString = nav.lastDestination {
            
            if let lastConversation = conversations.first(where: {$0.name == lastDestinationString}) {
                
                nav.navigate(to: .conversation(lastConversation))
            }
        } else {
            if nav.path.isEmpty, let firstConversation = conversations.last {
                nav.path = [Page.conversation(firstConversation)]
            }
        }
    }
    
    func fetchCurrentConversation() -> Conversation? {
        guard let lastPathItem = nav.path.last else {
            print("No items in path")
            return nil
        }
        switch lastPathItem {
        case .conversation(let conversation):
//            print("Current navigated conversation: \(conversation)")
            
            let current = conversations.first(where: {$0.persistentModelID == conversation.persistentModelID})
            
//            print("Current conversation from Query: \(String(describing: current))")
            return current
        default:
            return nil
        }
    }
    
    func testConversationExists(_ conversationName: String) -> Bool {
        return conversations.contains(where: {$0.name == conversationName})
    }
    
    func newConversation() {
        
        let newGrainientSeed = GrainientSettings.generateGradientSeed()
        let newConversation = Conversation(name: "New conversation", grainientSeed: newGrainientSeed)
        modelContext.insert(newConversation)
        nav.path.append(Page.conversation(newConversation))
        popup.showPopup(title: "Added new conversation")
    }
    
    func deleteCurrentConversation() {
        
        guard let conversation = fetchCurrentConversation() else {
            print("Unable to get current conversation")
            return
        }
        
        undoManager?.registerUndo(withTarget: conversation, handler: { conv in
//            print(conv)
        })
        modelContext.delete(conversation)
        
        try? modelContext.save()
        presentConversation()
        
        popup.showPopup(title: "Deleted conversation", message: "Navigated to next available conversation")
    }
    
    func generateTestMessages() -> [Message] {
        let messageCount: Int = 10
        var messages: [Message] = []
        
        for count in 0..<messageCount {
            let newMessage = Message(
                timestamp: Date.now + TimeInterval(count * 60),
                content: ExampleText.paragraphs.randomElement() ?? "Unable to get random",
                type: count.isMultiple(of: 2) ? .user : .assistant
            )
            messages.append(newMessage)
        }
        return messages
    } // END generate messages
    
    
}

#if DEBUG
#Preview {
    ContentView()
        .environment(ConversationHandler())
        .environmentObject(BanksiaHandler())
        .environmentObject(NavigationHandler())
        
        .environmentObject(PopupHandler())
        .environmentObject(SidebarHandler())
        .modelContainer(try! ModelContainer.sample())
        .padding(.top,1)
        .frame(width: 560, height: 700)
}
#endif
