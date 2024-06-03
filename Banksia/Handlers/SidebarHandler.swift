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

class SidebarHandler: Sidebarable, ObservableObject {

    @AppStorage("isSidebarDismissedKey") public var isSidebarDismissed: Bool = false
    
    var sidebarWidth: Double = 200
    
    /// From GeometryReader somewhere else in app
    @Published var windowSize: CGSize = .zero
    
    /// This value is the desired content width, not including the sidebar
    @Published var contentMinWidth: Double = 560
    
    let sidebarToggleBuffer: Double = 40
    
    static let sidebarPadding: Double = 12
    

    
    var isRoomForSidebar: Bool {
        return windowSize.width - sidebarToggleBuffer > contentMinWidth + sidebarToggleBuffer
    }
    
    var isSidebarVisible: Bool {
        !isSidebarDismissed && isRoomForSidebar
    }
    
    
}


