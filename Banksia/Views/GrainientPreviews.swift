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
    let spacing: Double = 16
    
    @State private var presets: [GrainientPreset] = [
        .sunset,
        .peachFuzz,
        .greenGlow,
        .toadstool,
        .sherbet,
        .lilac,
        .dyingStar,
        .bubblegum,
        .twilight
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
        
        VStack {
            //            Button {
            //                let newPreset = GrainientPreset(
            //                    seed: seed,
            //                    name: "New",
            //                    version: .v3
            //                )
            //
            //                presets.append(newPreset)
            //
            //            } label: {
            //                Label("Add new", systemImage: Icons.plus.icon)
            //            }
            
            LazyVGrid(columns: columns, spacing: spacing) {
                
                ForEach(presets) { preset in
                    Button {
                        seed = preset.seed
                    } label: {
                        Color.clear
                            .aspectRatio(1.3, contentMode: .fill)
                            .grainient(
                                seed: preset.seed,
                                version: preset.version,
                                grainOpacity: 0,
                                blurAmount: 14,
                                dimming: .constant(0)
                            )
                            .clipShape(.rect(cornerRadius: Styles.roundingMedium))

                    } // END button
                    .buttonStyle(.plain)
                }
            } // END lazy grid
        }
    }
}

#if DEBUG


#Preview {
    GrainientPreviews(seed: .constant(GrainientPreset.blueMetal.seed))
        .environmentObject(SidebarHandler())
        .frame(width: 500, height: 600)
        .padding()
}

#endif

