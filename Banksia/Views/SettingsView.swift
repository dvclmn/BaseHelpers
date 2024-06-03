//
//  SettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI
import SwiftData
import Grainient
import Swatches
import Popup
import Icons
import Button
import APIHandler
import GeneralStyles
import GeneralUtilities
import Form
import TextEditor
import MarkdownEditor
import GrainientPicker
import Sidebar
import ComponentBase
import ScrollMask
import SmoothGradient

enum SettingsTab: CaseIterable {
    case general
    case connections
    case shortcuts
    
    var name: String {
        switch self {
        case .general:
            "General"
        case .connections:
            "Connections"
        case .shortcuts:
            "Shortcuts"
        }
    }
    
    var icon: String {
        switch self {
        case .general:
            Icons.gear.icon
        case .connections:
            Icons.plug.icon
        case .shortcuts:
            Icons.command.icon
        }
    }
}


@MainActor
struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    
    @Environment(BanksiaHandler.self) private var bk
    
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @State private var settingsTab: SettingsTab = .general
    
    var body: some View {
        
        @Bindable var bk = bk
        
        VStack(spacing: 0) {
            
            SettingsTabBar()
            
            Form {
                
                switch settingsTab {
                    
                case .general:
                    
                    Settings_AssistantView()
                    
                case .connections:
                    Settings_ConnectionView()
                    
                case .shortcuts:
                    Settings_ShortcutsView()
                }
                
            } // END form
            .formStyle(.customForm())
            
            
        } // END main vstack
        .background(Swatch.slate.colour.opacity(min(1.0, max(0.6, bk.uiDimming * 1.6))))
//        .background(Swatch.slate.colour.opacity(min(1.0, bk.uiDimming * 1.5)))
        .background(.ultraThickMaterial)
        .frame(
            minWidth: 380,
            idealWidth: 500,
            maxWidth: 780,
            minHeight: 280,
            idealHeight: 600,
            maxHeight: .infinity
        )
        .grainient(seed: pref.defaultGrainientSeed, version: .v3)
        .onAppear {
            if isPreview {
                settingsTab = .general
            }
        }
        
    }
}

extension SettingsView {
    @ViewBuilder
    func SettingsTabBar() -> some View {
        HStack(spacing: 0) {
            
            ForEach(SettingsTab.allCases, id: \.name) { tab in
                Button {
                    settingsTab = tab
                } label: {
                    Label(tab.name, systemImage: tab.icon)
                }
                .buttonStyle(.customButton(
                    size: .huge,
                    status: settingsTab == tab ? .active : .normal,
                    hasBackground: false,
                    labelDisplay: .stacked
                ))
                .symbolVariant(.fill)
                
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 70,
            maxHeight: 70
        )
        .background(.ultraThinMaterial)
    }
}


#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SettingsView()
            .padding(.top,1)
    }
    .environment(BanksiaHandler())
    
    .environmentObject(Preferences())
    .environmentObject(PopupHandler())
    .environmentObject(SidebarHandler())
    .frame(width: 480, height: 700)
    
}

#endif



