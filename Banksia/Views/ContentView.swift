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
import MarkdownEditor

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var closeWindow
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Query private var conversations: [Conversation]
    
    @State private var isExporting: Bool = false
    @State private var isAlerting: Bool = false
    @State private var didExport: Bool = false
    
    @State private var alertMessage: String = ""
    @State private var exportLocation: URL? = nil
    
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
        .grainient(
            seed: nav.fetchCurrentConversationStatic(from: conversations)?.grainientSeed ?? bk.defaultGrainientSeed,
            version: .v3,
            dimming: $bk.uiDimming
        )
        .ignoresSafeArea()
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
                
            case .exportAll:
                exportAllData()
                conv.currentRequest = .none
                
            case .goToPrevious:
                goToPreviousConversation()
                conv.currentRequest = .none
                
            case .goToNext:
                goToNextConversation()
                conv.currentRequest = .none
                
            case .toggleSidebar:
                sidebar.toggleSidebar()
                conv.currentRequest = .none
                
            case .toggleToolbarExpanded:
                bk.isToolbarExpanded.toggle()
                conv.currentRequest = .none
                
            case .toggleToolbar:
                withAnimation(Styles.animation) {
                    bk.isToolbarShowing.toggle()
                }
                conv.currentRequest = .none
                
            case .toggleDebug:
                bk.isDebugShowing.toggle()
                conv.currentRequest = .none
                
            default:
                break
            }
        }
        //        .alert(isPresented: $isAlerting) {
        //            Alert(
        //                title: Text("Save Result"),
        //                message: Text(alertMessage),
        //                dismissButton: .default(Text("OK"))
        //            )
        //        }
        
        .alert("Export results", isPresented: $isAlerting) {
            if didExport, let exportLocation = exportLocation {
                Button("Show in Finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([exportLocation])
                }
            }
            Button("OK") {
                isAlerting = false
            }
        } message: {
            Text(alertMessage)
        }
        
        
        .task(id: nav.path) {
            print("Navigation path changed")
            conv.currentConversationID = nav.fetchCurrentConversationStatic(from: conversations)?.persistentModelID
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
    
    
    func goToNextConversation() {
        
        if let currentIndex = conversations.indexOf(nav.fetchCurrentConversationStatic(from: conversations)) {
            print("Current Index: \(currentIndex)")
            
            if let previousIndex = conversations.previousIndex(before: nav.fetchCurrentConversationStatic(from: conversations)) {
                print("Next Index: \(previousIndex), next conversation: \(conversations[previousIndex])")
                nav.navigate(to: Page.conversation(conversations[previousIndex]))
            } else {
                print("No previous conversation.")
            }
        } else {
            print("Conversation not found.")
        }
    }
    
    func goToPreviousConversation() {
        
        if let currentIndex = conversations.indexOf(nav.fetchCurrentConversationStatic(from: conversations)) {
            print("Current Index: \(currentIndex)")
            
            if let nextIndex = conversations.nextIndex(after: nav.fetchCurrentConversationStatic(from: conversations)) {
                print("Next Index: \(nextIndex), next conversation: \(conversations[nextIndex])")
                nav.navigate(to: Page.conversation(conversations[nextIndex]))
            } else {
                print("No next conversation.")
            }
            
        } else {
            print("Conversation not found.")
        }
    }
    
    
    func exportAllData() {
        if let url = bk.exportDataToJSON(conversations: conversations) {
            exportLocation = url
            didExport = true
            alertMessage = "File saved to: \(url.path)"
        } else {
            alertMessage = "Data was not exported."
            didExport = false
            exportLocation = nil
        }
        isAlerting = true
    }
    
    func presentConversation() {
        
        if let currentConversation = nav.fetchCurrentConversationStatic(from: conversations) {
            nav.navigate(to: .conversation(currentConversation))
            
        } else {
            if nav.path.isEmpty, let firstConversation = conversations.last {
                nav.path = [Page.conversation(firstConversation)]
            }
        }
    }
    

    
    
    
    func testConversationExists(_ conversationName: String) -> Bool {
        return conversations.contains(where: {$0.name == conversationName})
    }
    
    func newConversation() {
        
        let newGrainientSeed = GrainientSettings.generateGradientSeed()
        let newConversation = Conversation(
            name: ExampleText.conversationTitles.randomElement() ?? "Title here",
            grainientSeed: newGrainientSeed
        )
        modelContext.insert(newConversation)
        nav.path.append(Page.conversation(newConversation))
        popup.showPopup(title: "Added new conversation")
    }
    
    func deleteCurrentConversation() {
        
        guard let conversation = nav.fetchCurrentConversationStatic(from: conversations) else {
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
        .frame(width: 560, height: 740)
}
#endif
