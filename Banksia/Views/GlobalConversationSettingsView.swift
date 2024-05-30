//
//  GlobalConversationSettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/4/2024.
//

import SwiftUI
import GeneralStyles
import GeneralUtilities
import Icons
import Form

struct GlobalConversationSettingsView: View {
    @EnvironmentObject var pref: Preferences
    
    @State private var isEditingLongFormText: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text("Global Conversation preferences")
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal, Styles.paddingToMatchForm)
                    .padding(.bottom, -8)
                
                Form {

                    
                } // END form
                .formStyle(.grouped)
            } // END main vstack
            .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .leading)
            .padding(Styles.paddingGenerous - Styles.paddingToMatchForm)
            
        } // END scroll view
        .scrollContentBackground(.hidden)
        .background(.contentBackground)
        //        .background(.ultraThinMaterial)
        .frame(minWidth: 340 , minHeight: 400)
    }
}

//#Preview {
//    GlobalConversationSettingsView()
//        .environmentObject(Preferences())
//        .frame(width: 380, height: 700)
//    
//}
