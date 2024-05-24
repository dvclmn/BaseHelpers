//
//  NavigationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import Foundation
import SwiftUI
import Styles
import Navigation
import Icons

enum Page: Destination {
    
    case conversation(Conversation)
    
    var id: String {
        self.name
    }
    
    var name: String {
        switch self {
        case .conversation(let conversation):
            return conversation.name
        }
    }
    
    var icon: String {
        switch self {
        case .conversation(let conversation):
            return conversation.icon ?? Icons.message.icon
        }
    }
    
    var grainientSeed: Int? {
        switch self {
        case .conversation(let conversation):
            return conversation.grainientSeed
        }
    }
}

public class NavigationHandler<Page: Destination>: Navigable, ObservableObject {
    
    @Published public var path: [Page]
    @AppStorage("lastDestinationKey") public var lastDestination: Int?
    
    public init(
        path: [Page] = []
    ) {
        self.path = path
    }

    public var navigationTitle: String? {
        if let pathLast = self.path.last?.name {
            return pathLast
        } else {
            return nil
        }
    }
    public func navigate(to page: Page) {
        if path.last != page {
            path.append(page)
        } else {
            print("Already on \(page.name)")
        }
    }
    
    
    //    public func goBack() {
    //        if canGoBack {
    //            path.removeLast()
    //        }
    //    }
}

