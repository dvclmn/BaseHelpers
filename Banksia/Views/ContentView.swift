//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navHandler = NavHandler()
    var body: some View {
        TwoColumnContentView()
                    .environment(navHandler)
    }
}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
