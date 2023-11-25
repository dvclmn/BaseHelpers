//
//  SettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    
    var body: some View {
        
        VStack {
            TabView {
                
                GeneralSettingsView()
                    .tabItem {
                        Label("General", systemImage: "wrench.and.screwdriver.fill")
                    }
                
            } // END Tab view
            
            
            
        } // END Vstack
        .padding(.horizontal, 80)
        .padding(.vertical, 20)
        .frame(width: 500)
        
    }
}

#Preview {
    SettingsView()
        .environment(BanksiaHandler())
}
