//
//  File.swift
//  
//
//  Created by Dave Coleman on 11/8/2024.
//

import Foundation


public struct GrainientPreset: Identifiable, Hashable, Codable, Equatable {
  public var id: UUID
  public var seed: Int
  public var name: String
  public var version: GrainientVersion
  
  
  public init(
    id: UUID = UUID(),
    seed: Int = 358690,
    name: String = "Example",
    version: GrainientVersion = GrainientVersion.v2
  ) {
    self.id = id
    self.seed = seed
    self.name = name
    self.version = version
  }
}

public extension GrainientPreset {
  
  //    /// Version 1
  //    static let oldCopper        = GrainientPreset(seed: 45976, name: "Old copper", version: .v1)
  //    static let greyPurple       = GrainientPreset(seed: 53688, name: "Grey purple", version: .v1)
  //    static let metallic         = GrainientPreset(seed: 69698, name: "Metallic", version: .v1)
  //    static let electricPurple   = GrainientPreset(seed: 88191, name: "Electric purple", version: .v1)
  //    static let chalkyBlue       = GrainientPreset(seed: 11146, name: "Chalky blue", version: .v1)
  //    static let lagoon           = GrainientPreset(seed: 58718, name: "Lagoon", version: .v1)
  //    static let deepPurple       = GrainientPreset(seed: 11044, name: "Deep purple", version: .v1)
  //    static let purpleHalo       = GrainientPreset(seed: 33260, name: "Purple halo", version: .v1)
  //    static let blueSky          = GrainientPreset(seed: 87242, name: "Blue sky", version: .v1)
  //
  //    /// Version 2
  //    static let holoMetal        = GrainientPreset(seed: 70415, name: "Holo metal", version: .v2)
  //    static let oliveGarden      = GrainientPreset(seed: 42985, name: "Olive garden", version: .v2)
  //    static let gunMetalGrey     = GrainientPreset(seed: 63693, name: "Gunmetal Grey", version: .v2)
  //    static let oceana           = GrainientPreset(seed: 95376, name: "Oceana", version: .v2)
  //    static let blueMetal        = GrainientPreset(seed: 73506, name: "Blue metal", version: .v2)
  //    static let algae            = GrainientPreset(seed: 93628, name: "Algae", version: .v2)
  
  
  static let sunset            = GrainientPreset(seed: 26171, name: "Sunset", version: .v3)
  static let peachFuzz         = GrainientPreset(seed: 47917, name: "Peach Fuzz", version: .v3)
  static let greenGlow         = GrainientPreset(seed: 81745, name: "Green Glow", version: .v3)
  static let toadstool         = GrainientPreset(seed: 61720, name: "Toadstool", version: .v3)
  static let sherbet         = GrainientPreset(seed: 78671, name: "Sherbet", version: .v3)
  static let lilac         = GrainientPreset(seed: 50411, name: "Lilac", version: .v3)
  static let dyingStar         = GrainientPreset(seed: 57001, name: "Dying Star", version: .v3)
  static let bubblegum         = GrainientPreset(seed: 27079, name: "Bubblegum", version: .v3)
  static let twilight         = GrainientPreset(seed: 33785, name: "Twilight", version: .v3)
  static let ozone         = GrainientPreset(seed: 68935, name: "Ozone", version: .v3)
  static let nucleus         = GrainientPreset(seed: 14806, name: "Nucleus", version: .v3)
  static let swampy         = GrainientPreset(seed: 58259, name: "Swampy", version: .v3)
  static let underwater         = GrainientPreset(seed: 35498, name: "Underwater", version: .v3)
  static let tunnelEntrance         = GrainientPreset(seed: 45837, name: "Tunnel Entrance", version: .v3)
  static let shrinkingViolet         = GrainientPreset(seed: 94281, name: "Shrinking Violet", version: .v3)
  static let dustStorm         = GrainientPreset(seed: 14687, name: "Dust Storm", version: .v3)
  static let pretty         = GrainientPreset(seed: 34549, name: "Pretty", version: .v3)
  static let darkToLight         = GrainientPreset(seed: 923765, name: "Dark to Light", version: .v3)
  static let moss         = GrainientPreset(seed: 903099, name: "Moss", version: .v3)
  static let trippy         = GrainientPreset(seed: 725389, name: "Trippy", version: .v3)
  static let jungleFlower         = GrainientPreset(seed: 31251, name: "Jungle Flower", version: .v3)
  
  
  
}
