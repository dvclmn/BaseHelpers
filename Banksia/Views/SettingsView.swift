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
import KeychainHandler
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
    case interface
    case assistant
    case connections
    case shortcuts
    
    var name: String {
        switch self {
        case .interface:
            "Interface"
        case .assistant:
            "Assistant"
        case .connections:
            "Connections"
        case .shortcuts:
            "Shortcuts"
        }
    }
    
    var icon: String {
        switch self {
        case .interface:
            Icons.gear.icon
        case .assistant:
            Icons.shocked.icon
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
    
    @EnvironmentObject var popup: PopupHandler
    
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @State private var settingsTab: SettingsTab = .interface
    
    var body: some View {
        
        VStack(spacing: 0) {
            
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
            
            Form {
                
                switch settingsTab {
                    
                case .interface:
                    
                    // MARK: - Name
                    LabeledContent {
                        TextField("", text: bk.$userName.boundString, prompt: Text("Enter your name"))
                            .textFieldStyle(.customField(text: bk.$userName.boundString))
                    } label: {
                        Label("Your Name", systemImage: Icons.person.icon)
                    }
                    
                    
                    // MARK: - UI Dimming
                    LabeledContent {
                        Text("\(bk.uiDimming * 100, specifier: "%.0f")%")
                            .monospacedDigit()
                        Slider(
                            value: $bk.uiDimming,
                            in: 0.01...0.89)
                        .controlSize(.mini)
                        .tint(Swatch.lightGrey.colour)
                        .frame(
                            minWidth: 80,
                            maxWidth: 140
                        )
                    } label: {
                        Label("UI Dimming", systemImage: Icons.contrast.icon)
                    }
                    
                    // MARK: - Grainient
                    LabeledContent {
                        GrainientPicker(
                            seed: $bk.defaultGrainientSeed,
                            popup: popup,
                            viewSeedEnabled: false
                        )
                    } label: {
                        Label("Default background", systemImage: Icons.gradient.icon)
                        Text("Customise the gradient background that appears when no conversation is selected.")
                    }
                    
                    GrainientPreviews(seed: $bk.defaultGrainientSeed)
                    
                    Settings_AssistantView()
                    
                case .assistant:
                    EmptyView()
                case .connections:
                    Settings_ConnectionView()
                    
                case .shortcuts:
                    Settings_ShortcutsView()
                }
                
            } // END form
            .formStyle(.customForm())
            
            
        } // END main vstack
        .background(Swatch.slate.colour.opacity(0.6))
        .background(.ultraThickMaterial)
        .frame(
            minWidth: 380,
            idealWidth: 500,
            maxWidth: 780,
            minHeight: 280,
            idealHeight: 600,
            maxHeight: .infinity
        )
        .grainient(seed: bk.defaultGrainientSeed, version: .v1)
        .onAppear {
            if isPreview {
                settingsTab = .interface
            }
        }
        
    }
}


#if DEBUG

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SettingsView()
            .padding(.top,1)
    }
    .environmentObject(BanksiaHandler())
    
    .environmentObject(PopupHandler())
    .environmentObject(SidebarHandler())
    .frame(width: 480, height: 300)
    
}

#endif


public struct CustomLabeledContent: LabeledContentStyle {
    
    var size: ElementSize
    var labelDisplay: LabelDisplay
    
    public func makeBody(configuration: Configuration) -> some View {
        
        HStack(alignment: .firstTextBaseline, spacing: 24) {
            VStack(alignment: .leading) {
                configuration.label
            }
            .labelStyle(.customLabel())
            
            HStack {
                configuration.content
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        
    }
}

public extension LabeledContentStyle where Self == CustomLabeledContent {
    static func customLabeledContent(
        size: ElementSize = .normal,
        labelDisplay: LabelDisplay = .titleAndIcon
    ) -> CustomLabeledContent {
        CustomLabeledContent(
            size: size,
            labelDisplay: labelDisplay
        )
    }
}

public struct CustomFormStyle: FormStyle {
    
    @State private var isMasked: Bool = true
    @State private var isScrolling: Bool = false
    
    public func makeBody(configuration: Configuration) -> some View {
        
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                configuration.content
                    .labeledContentStyle(.customLabeledContent())
            }
            .padding(Styles.paddingGenerous)
            .onScrollThreshold(
                threshold: 10,
                isScrolling: $isScrolling
            ) { thresholdReached in
                withAnimation(Styles.animation) {
                    isMasked = thresholdReached
                }
            }
//            .compositingGroup()
        }
        .scrollMask(isMasked, maskMode: .overlay)
        .coordinateSpace(name: "scroll")
        .scrollIndicators(.hidden)
    }
}
public extension FormStyle where Self == CustomFormStyle {
    static func customForm(
    ) -> CustomFormStyle {
        CustomFormStyle(
        )
    }
}



