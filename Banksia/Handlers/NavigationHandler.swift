//
//  NavigationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import Foundation
import SwiftUI
import Sidebar
import Styles
import Navigation

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


public class SidebarHandler: Sidebarable, ObservableObject {

    @AppStorage("isSidebarShowingKey") public var isSidebarShowing: Bool = true
    @AppStorage("sidebarWidthKey") public var sidebarWidth: Double = 200
    
    /// From GeometryReader somewhere else in app
    @Published public var contentWidth: Double

    private let sidebarToggleBuffer: Double = 80
    private let contentMinWidth: Double = 300
    public static let sidebarPadding: Double = 14

    public var isRoomForSidebar: Bool {
        return contentWidth - sidebarToggleBuffer > contentMinWidth + sidebarToggleBuffer
    }
    
    public init(
        contentMinWidth: Double = 100,
        sidebarToggleBuffer: Double = 60,
        contentWidth: Double = 400
    ) {
        self.contentWidth = contentWidth
    }

    public func toggleSidebar() {
        isSidebarShowing.toggle()
    }

    public func updateContentWidth(_ width: Double) {
        contentWidth = width
    }
}


