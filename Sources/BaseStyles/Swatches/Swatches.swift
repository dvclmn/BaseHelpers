//
//  Swatches.swift
//
//
//  Created by Dave Coleman on 25/6/2024.
//

import Foundation
import SwiftUI

public enum ContrastType {
  case bright
  case mid
  case dark
}


// MARK: - Swatches
public enum Swatch: String, Codable, CaseIterable, Identifiable, Sendable {
  
  /// Whites/greys
  case offWhite
  case lightGrey
  case grey
  
  case pewter
  case sandy
  case chalkBlue
  case electricBlue
  case navy
  case hazel
  case earth
  case lavendar
  case hazyPurple
  case eggplant
  case peach
  case peachVibrant
  case brightRed
  case lemon
  case aqua
  case olive
  case scarlet
  case darkRed
  case plum
  
  /// Greys
  case midGrey
  case slate
  case darkGrey
  
  /// Near-black
  case darkPlum
  case darkBlack
  
  /// System colours
  case red
  case orange
  case yellow
  case green
  case mint
  case teal
  case cyan
  case blue
  case indigo
  case purple
  case pink
  case brown
  case white
  case gray
  case black
  
  public var id: String {
    self.rawValue
  }
  
  public enum Category {
    case decorative
    case ui
  }
  
  public var category: Swatch.Category {
    switch self {
      case .midGrey:
          .ui
      default:
          .decorative
    }
  }
  
  public var colour: Color {
    switch self {
        
        
      case .red: Color.red
      case .orange: Color.orange
      case .yellow: Color.yellow
      case .green: Color.green
      case .mint: Color.mint
      case .teal: Color.teal
      case .cyan: Color.cyan
      case .blue: Color.black
      case .indigo: Color.indigo
      case .purple: Color.purple
      case .pink: Color.pink
      case .brown: Color.brown
      case .white: Color.white
      case .gray: Color.gray
      case .black: Color.black
        
      case .offWhite:
        Color(.displayP3, red: 0.901, green: 0.888, blue: 0.921, opacity: 1)
        
      case .pewter:
        Color(.displayP3, red: 0.6, green: 0.678, blue: 0.66, opacity: 1)
        
      case .sandy:
        Color(.displayP3, red: 0.86, green: 0.681, blue: 0.522, opacity: 1)
        
      case .lightGrey:
        Color(.displayP3, red: 0.778, green: 0.765, blue: 0.797, opacity: 1)
        
      case .grey:
        Color(.displayP3, red: 0.553, green: 0.534, blue: 0.562, opacity: 1)
        
      case .chalkBlue:
        Color(.displayP3, red: 0.602, green: 0.626, blue: 0.823, opacity: 1)
        
      case .electricBlue:
        Color(.displayP3, red: 0.138, green: 0.24, blue: 0.792, opacity: 1)
        
      case .navy:
        Color(.displayP3, red: 0.078, green: 0.19, blue: 0.466, opacity: 1)
        
      case .hazel:
        Color(.displayP3, red: 0.406, green: 0.242, blue: 0.183, opacity: 1)
        
      case .earth:
        Color(.displayP3, red: 0.238, green: 0.216, blue: 0.19, opacity: 1)
        
      case .lavendar:
        Color(.displayP3, red: 0.596, green: 0.495, blue: 0.969, opacity: 1)
        
      case .hazyPurple:
        Color(.displayP3, red: 0.41, green: 0.373, blue: 0.619, opacity: 1)
        
      case .lemon:
        Color(.displayP3, red: 0.911, green: 0.779, blue: 0.595, opacity: 1)
        
      case .aqua:
        Color(.displayP3, red: 0.432, green: 0.713, blue: 0.642, opacity: 1)
        
      case .olive:
        Color(.displayP3, red: 0.377, green: 0.38, blue: 0.276, opacity: 1)
        
      case .scarlet:
        Color(.displayP3, red: 0.726, green: 0.31, blue: 0.261, opacity: 1)
        
      case .slate:
        Color(.displayP3, red: 0.088, green: 0.088, blue: 0.11, opacity: 1)
        
      case .darkRed:
        Color(.displayP3, red: 0.368, green: 0.156, blue: 0.154, opacity: 1)
        
      case .darkGrey:
        Color(.displayP3, red: 0.082, green: 0.082, blue: 0.086, opacity: 1)
        
      case .darkPlum:
        Color(.displayP3, red: 0.077, green: 0.074, blue: 0.081, opacity: 1)
        
      case .midGrey:
        Color(.displayP3, red: 0.114, green: 0.114, blue: 0.121, opacity: 1)
        
      case .darkBlack:
        Color(.displayP3, red: 0.055, green: 0.055, blue: 0.058, opacity: 1)
        
      case .plum:
        Color(.displayP3, red: 0.093, green: 0.087, blue: 0.101, opacity: 1)
        
      case .eggplant:
        Color(.displayP3, red: 0.815, green: 0.733, blue: 0.959, opacity: 1)
        
      case .peach:
        Color(.displayP3, red: 0.806, green: 0.536, blue: 0.422, opacity: 1)
        
      case .peachVibrant:
        Color(.displayP3, red: 0.899, green: 0.528, blue: 0.438, opacity: 1)
        //        Color(hex: "D98566")
        
      case .brightRed:
        Color(.displayP3, red: 0.89, green: 0.254, blue: 0.24, opacity: 1)
        
    }
  } // END color property
  
  public static var systemColours: Set<Swatch> {
    [
      .red,
      .orange,
      .yellow,
      .green,
      .mint,
      .teal,
      .cyan,
      .blue,
      .indigo,
      .purple,
      .pink,
      .brown,
      .white,
      .gray,
      .black,
    ]
  }
  
  public static func random(range: SwatchRange = SwatchRange.all) -> Swatch {
    
    let result = range.swatches.filter { swatch in
      !Swatch.systemColours.contains(swatch)
    }
    return result.randomElement() ?? Swatch.chalkBlue
  }
  
  
} // END swatch extension

public enum SwatchRange {
  case all
  case imageBackgrounds
  
  var swatches: [Swatch] {
    switch self {

      case .all:
        Swatch.allCases
      case .imageBackgrounds:
        [
          .pewter,
          .sandy,
          .lightGrey,
          //                .grey,
          .chalkBlue,
          //                .aqua,
          //                .eggplant,
            .peach,
          .lavendar,
          //                .hazyPurple,
          .olive
        ]
    }
  }
}
