//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TwoColumnContentView()
            
    }
}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
