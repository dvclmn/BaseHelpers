//
//  Settings+ShortcutsView.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import KeyboardShortcuts

struct Settings_ShortcutsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Summon Banksia:", name: .summonBanksia)
        }
    }
}

#Preview {
    Settings_ShortcutsView()
}
