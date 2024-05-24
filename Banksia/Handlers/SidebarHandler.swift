//
//  SidebarHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 24/5/2024.
//

import Foundation
import SwiftUI
import Sidebar
import Styles

public class SidebarHandler: Sidebarable, ObservableObject {
    
    @AppStorage("isSidebarDismissedKey") public var isSidebarDismissed: Bool = false
    
    public var sidebarWidth: Double = 200
    
    /// From GeometryReader somewhere else in app
    @Published public var windowWidth: Double
    
    /// This value is the desired content width, not including the sidebar
    @Published var contentMinWidth: Double = 480
    
    let sidebarToggleBuffer: Double = 20
    public static let sidebarPadding: Double = 14
    
    public var isRoomForSidebar: Bool {
        return windowWidth - sidebarToggleBuffer > contentMinWidth + sidebarToggleBuffer
    }
    
    var isSidebarVisible: Bool {
        !isSidebarDismissed && isRoomForSidebar
    }
    
    func requestRoomForSidebar() {
        let requiredWidth = contentMinWidth + sidebarWidth + sidebarToggleBuffer
        let widthDeficit = max(0, requiredWidth - windowWidth)
        contentMinWidth += widthDeficit
        
        // Trigger window resize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(Styles.animation){
                self.contentMinWidth -= widthDeficit
            }
        }
    }
    
    public init(
        windowWidth: Double = 400
    ) {
        self.windowWidth = windowWidth
    }
}


