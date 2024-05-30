//
//  GrainientPreviews.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import Grainient
import GeneralStyles
import Icons
import Sidebar

struct GrainientPreviews: View {
    
    @Binding var seed: Int
    let spacing: Double = 20
    
    @State private var presets: [GrainientPreset] = [
        .algae, .blueSky, .electricPurple, .gunMetalGrey, .lagoon, .oliveGarden
    ]
    
    var body: some View {
        
        let columns: [GridItem] = [
            GridItem(
                .flexible(minimum: 40),
                spacing: spacing
            ),
            GridItem(
                .flexible(minimum: 40),
                spacing: spacing
            ),
            GridItem(
                .flexible(minimum: 40),
                spacing: spacing
            )
        ]
        
        Button {
            let newPreset = GrainientPreset(
                seed: seed,
                name: "New",
                version: .v2
            )
            
            presets.append(newPreset)
            
        } label: {
            Label("Add new", systemImage: Icons.plus.icon)
        }
        
        LazyVGrid(columns: columns, spacing: spacing, content: {
            ForEach(presets) { preset in
                Color.clear
                    .aspectRatio(1.3, contentMode: .fill)
                    .grainient(
                        seed: preset.seed,
                        version: preset.version,
                        grainOpacity: 0,
                        blurAmount: 10,
                        dimming: .constant(0)
                    )
                    .clipShape(.rect(cornerRadius: Styles.roundingMedium))
                    .onTapGesture {
                        seed = preset.seed
                    }
            }
        })
    }
}

//#Preview {
//    GrainientPreviews(seed: .constant(GrainientPreset.blueMetal.seed))
//        .environmentObject(SidebarHandler())
//}
