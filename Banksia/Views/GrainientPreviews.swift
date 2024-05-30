//
//  GrainientPreviews.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import Grainient
import GeneralStyles

struct GrainientPreviews: View {
    
    @Binding var seed: Int
    let spacing: Double = 20
    
    let presets: [GrainientPreset] = [
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
        
        LazyVGrid(columns: columns, spacing: spacing, content: {
            ForEach(presets) { preset in
                Color.clear
                    .aspectRatio(1.3, contentMode: .fill)
                    .grainient(seed: preset.seed, grainOpacity: 0)
                    .clipShape(.rect(cornerRadius: Styles.roundingMedium))
                    .onTapGesture {
                        seed = preset.seed
                    }
            }
        })
    }
}

#Preview {
    GrainientPreviews(seed: .constant(GrainientPreset.blueMetal.seed))
}
