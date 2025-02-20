//
//  File.swift
//
//
//  Created by Dave Coleman on 11/8/2024.
//

import Foundation

public struct Grainient: Identifiable, Hashable, Codable, Equatable, Sendable {
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

extension Grainient {

  /// IMPORTANT:
  ///
  /// If the fundamentals of  ``GrainientSettings`` are changed, then the
  /// below will break (i.e., not match the colours/description for each preset).
  ///
  ///
  public static let sunset = Self(seed: 26171, name: "Sunset", version: .v3)
  public static let peachFuzz = Self(seed: 47917, name: "Peach Fuzz", version: .v3)
  public static let greenGlow = Self(seed: 81745, name: "Green Glow", version: .v3)
  public static let toadstool = Self(seed: 61720, name: "Toadstool", version: .v3)
  public static let sherbet = Self(seed: 78671, name: "Sherbet", version: .v3)
  public static let lilac = Self(seed: 50411, name: "Lilac", version: .v3)
  public static let dyingStar = Self(seed: 57001, name: "Dying Star", version: .v3)
  public static let bubblegum = Self(seed: 27079, name: "Bubblegum", version: .v3)
  public static let twilight = Self(seed: 33785, name: "Twilight", version: .v3)
  public static let ozone = Self(seed: 68935, name: "Ozone", version: .v3)
  public static let nucleus = Self(seed: 14806, name: "Nucleus", version: .v3)
  public static let swampy = Self(seed: 58259, name: "Swampy", version: .v3)
  public static let underwater = Self(seed: 35498, name: "Underwater", version: .v3)
  public static let tunnelEntrance = Self(seed: 45837, name: "Tunnel Entrance", version: .v3)
  public static let shrinkingViolet = Self(seed: 94281, name: "Shrinking Violet", version: .v3)
  public static let dustStorm = Self(seed: 14687, name: "Dust Storm", version: .v3)
  public static let pretty = Self(seed: 34549, name: "Pretty", version: .v3)
  public static let darkToLight = Self(seed: 923765, name: "Dark to Light", version: .v3)
  public static let moss = Self(seed: 903099, name: "Moss", version: .v3)
  public static let trippy = Self(seed: 725389, name: "Trippy", version: .v3)
  public static let jungleFlower = Self(seed: 31251, name: "Jungle Flower", version: .v3)
  public static let sunset02 = Self(seed: 67024, name: "Sunset 02", version: .v3)
  public static let greenVoid = Self(seed: 29189, name: "Green Void", version: .v3)
  public static let something = Self(seed: 86112, name: "Something", version: .v3)

  public static let allPresets: [Self] = [
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
    greenVoid,
  ]
}
