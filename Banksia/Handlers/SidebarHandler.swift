//
//  SidebarHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 24/5/2024.
//

import Foundation
import SwiftUI
import Sidebar
import GeneralStyles

class SidebarHandler: Sidebarable, ObservableObject, Equatable {
    static func == (lhs: SidebarHandler, rhs: SidebarHandler) -> Bool {
        return lhs.isSidebarDismissed == rhs.isSidebarDismissed &&
        lhs.sidebarWidth == rhs.sidebarWidth &&
        lhs.windowSize == rhs.windowSize &&
        lhs.contentMinWidth == rhs.contentMinWidth &&
        lhs.sidebarToggleBuffer == rhs.sidebarToggleBuffer
    }
    
    @AppStorage("isSidebarDismissedKey") public var isSidebarDismissed: Bool = false
    
    var sidebarWidth: Double = 200
    
    /// From GeometryReader somewhere else in app
    @Published var windowSize: CGSize = .zero
    
    /// This value is the desired content width, not including the sidebar
    @Published var contentMinWidth: Double = 480
    
    let sidebarToggleBuffer: Double = 20
    
    static let sidebarPadding: Double = 14
    
}


