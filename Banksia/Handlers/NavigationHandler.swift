//
//  NavigationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import Foundation
import SwiftUI
import GeneralStyles
import Navigation
import Icons
import Grainient


class NavigationHandler: Navigable, ObservableObject {
    
    @Published public var path: [Page] = []
    
    @AppStorage("currentDestinationKey") var currentDestination: String?

    var navigationTitle: String? {
        if let pathLast = self.path.last?.name {
            return pathLast
        } else {
            return nil
        }
    }
    func navigate(to page: Page) {
        if path.last != page {
            path.append(page)
        } else {
            print("Already on \(page.name)")
        }
    }
    
    func updateLastDestination() {
        if let last = path.last {
            currentDestination = last.id
        } else {
            print("No last item in path")
        }
    }
    

    func fetchCurrentConversationStatic(from conversations: [Conversation]) -> Conversation? {
        
        print("\n\n|--- Fetch current conversation --->\n")
        
        guard let currentDestinationString = currentDestination else {
            print("No last destination")
            return nil
        }
        
        guard let current = conversations.first(where: {"\($0.persistentModelID)" == currentDestinationString}) else {
            print("No matching converation")
            return nil
        }
        
        print("Current conversation is: \(current.name)")
        return current
    }
    
    
    
    
    //    public func goBack() {
    //        if canGoBack {
    //            path.removeLast()
    //        }
    //    }
}

enum Page: Destination {
    
    case conversation(Conversation)
    case feedback
    case settings
    
    var id: String {
        switch self {
        case .conversation(let conversation):
            return "\(conversation.persistentModelID)"
        default:
            return self.name
        }
    }
    
    var name: String {
        switch self {
        case .conversation(let conversation):
            return conversation.name
        case .feedback:
            return "Feedback"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .conversation(let conversation):
            return conversation.icon ?? Icons.message.icon
        case .feedback:
            return Icons.horn.icon
        case .settings:
            return Icons.gear.icon
        }
    }
    
    var grainientSeed: Int? {
        switch self {
        case .conversation(let conversation):
            return conversation.grainientSeed
        case .feedback:
            return GrainientPreset.algae.seed
        default:
            return GrainientPreset.chalkyBlue.seed
        }
    }
}
