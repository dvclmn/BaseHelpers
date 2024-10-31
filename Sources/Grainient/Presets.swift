//
//  File.swift
//
//
//  Created by Dave Coleman on 11/8/2024.
//

import Foundation


public struct GrainientPreset: Identifiable, Hashable, Codable, Equatable, Sendable {
  public var id: Int {
    self.seed
  }
  public var seed: Int
  public var name: String
  public var version: GrainientVersion
  
  
  public init(
    seed: Int = 358690,
    name: String = "Example",
    version: GrainientVersion = GrainientVersion.v3
  ) {
    self.seed = seed
    self.name = name
    self.version = version
  }
}

public extension GrainientPreset {
  
  /// IMPORTANT:
  ///
  /// If the fundamentals of  ``GrainientSettings`` are changed, then the
  /// below will break (i.e., not match the colours/description for each preset).
  ///
  ///
  static let sunset             = GrainientPreset(seed: 26171, name: "Sunset", version: .v3)
  static let peachFuzz          = GrainientPreset(seed: 47917, name: "Peach Fuzz", version: .v3)
  static let greenGlow          = GrainientPreset(seed: 81745, name: "Green Glow", version: .v3)
  static let toadstool         = GrainientPreset(seed: 61720, name: "Toadstool", version: .v3)
  static let sherbet            = GrainientPreset(seed: 78671, name: "Sherbet", version: .v3)
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
  static let sunset02         = GrainientPreset(seed: 67024, name: "Sunset 02", version: .v3)
  static let greenVoid         = GrainientPreset(seed: 29189, name: "Green Void", version: .v3)
  
  static let allPresets: [GrainientPreset] = [
    sunset,
    peachFuzz,
    greenGlow,
    toadstool,
    sherbet,
    lilac,
    dyingStar,
    bubblegum,
    twilight,
    ozone,
    nucleus,
    swampy,
    underwater,
    tunnelEntrance,
    shrinkingViolet,
    dustStorm,
    pretty,
    darkToLight,
    moss,
    trippy,
    jungleFlower,
    sunset02,
    greenVoid
  ]
}
