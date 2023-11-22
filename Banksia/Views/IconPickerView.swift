//
//  IconPickerView.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import SwiftUI

struct IconPickerView: View {
    
    var conversation: Conversation
    var iconWidth: Double = 50
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(iconWidth)), count: 5)
    }
    @State private var hoveredIcons: Set<String> = []
    
    @State private var iconSearch: String = ""
    
    var body: some View {
        
        VStack {
            TextField("Search Icons", text: $iconSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 10,
                    pinnedViews: PinnedScrollableViews
                ) {
                    ForEach(ConversationIcon.icons.filter { icon in
                        iconSearch.isEmpty || icon.name.contains(iconSearch) || icon.searchTerms.contains(where: { $0.contains(iconSearch) })
                    }, id: \.self) { icon in
                        Image(systemName: icon.name)
                            .symbolRenderingMode(.hierarchical)
                            .fontStyle(.title1)
                            .frame(width: iconWidth, height: iconWidth)
                            .background(hoveredIcons.contains(icon.name) ? Color.gray.opacity(0.2) : Color.clear)
                            .clipShape(.rect(cornerRadius: 12))
                            .onHover { hovering in
                                if hovering {
                                    hoveredIcons.insert(icon.name)
                                } else {
                                    hoveredIcons.remove(icon.name)
                                }
                            }
                            .onTapGesture(perform: {
                                conversation.icon = icon.name
                            })
                    }
                } // END lazy grid
                .padding()
            } // END scrollview
            
        } // END Vstack
        .frame(maxHeight:300)
        .background(VisualEffectView())
    }
}

#Preview {
    IconPickerView(conversation: .appKitDrawing).environmentObject(BanksiaHandler())
    
}
