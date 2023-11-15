//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var bk = BanksiaHandler()
    var body: some View {
        TwoColumnContentView()
            .environment(bk)
    }
}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
