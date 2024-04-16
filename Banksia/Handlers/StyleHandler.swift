//
//  StyleHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI

struct Styles {
    static let cornerRadiusSmall:       CGFloat = 6
    static let cornerRadiusLarge:       CGFloat = 10
    
    static let paddingToMatchForm:      Double = 22
    static let paddingGenerous:         Double = 28
    static let paddingContainer:        Double = 48
    
    /// Animation
    static let animationQuick:          Animation = .easeOut(duration: 0.08)
    static let animation:               Animation = .easeOut(duration: 0.2)
    static let animationSlower:         Animation = .easeInOut(duration: 0.6)
    
    /// Rounding
    static let roundingTiny:            Double = 2
    static let roundingSmall:           Double = 5
    static let roundingMedium:          Double = 8
    static let roundingLarge:           Double = 12
    static let roundingHuge:            Double = 20
    
}

// MARK: - Icons
enum Icons: String, CaseIterable, Identifiable, Codable {
    
    
    case stats              = "chart.dots.scatter"
    case statsAlt           = "chart.pie"
    case refresh            = "arrow.triangle.2.circlepath"
    case trash              = "trash"
    case controller         = "gamecontroller"
    case controllerAlt      = "arcade.stick.console"
    case connection         = "powerplug"
    case connectionAlt      = "powercord"
    case loggedOut          = "poweroutlet.type.b"
    case connectionAlt3     = "poweroutlet.type.i"
    case connectionAlt4     = "spigot"
    case connectionAlt5     = "antenna.radiowaves.left.and.right"
    //    case connectionAlt6     = "glowplug"
    case heart              = "heart"
    case game               = "sdcard"
    case back               = "chevron.backward"
    case forward            = "chevron.forward"
    case debug              = "ladybug"
    case store              = "storefront"
    case importSource       = "square.and.arrow.down"
    case person             = "person"
    case question           = "questionmark.circle"
    case grid               = "rectangle.grid.3x2"
    case portrait           = "rectangle.portrait"
    case plus               = "plus"
    case plusSquare         = "plus.app"
    case info               = "info.circle"
    case popup              = "text.bubble"
    case message            = "bubble"
    case image              = "photo"
    case imageMulti         = "photo.on.rectangle.angled"
    case options            = "slider.horizontal.3"
    case gear               = "gearshape"
    case glasses            = "eyeglasses"
    case bookmark           = "bookmark"
    case status             = "rays"
    case pause              = "pause"
    case stop               = "stop"
    case stopAlt            = "octagon"
    case clock              = "clock"
    case tick               = "checkmark"
    case gift               = "gift"
    case giftAlt            = "app.gift"
    case eye                = "eye"
    case eyeSquare          = "eye.square"
    case eyeSlash           = "eye.slash"
    case title              = "textformat"
    case cloud              = "cloud"
    case circle             = "circle"
    case binoculars         = "binoculars"
    case hashtag            = "number"
    case hashtagAlt         = "grid"
    case sidebar            = "sidebar.left"
    case list               = "square.stack"
    case drag               = "line.3.horizontal"
    case library            = "books.vertical"
    case trophy             = "trophy"
    case globe              = "globe.asia.australia"
    case cross              = "xmark"
    case crossSquare        = "x.square"
    case arrowDown          = "arrow.down"
    case swirl              = "glowplug"
    case dismissKeyboard    = "keyboard.chevron.compact.down"
    case go                 = "arrow.up.right"
    case sparkle            = "sparkles"
    case empty              = "light.max"
    case search             = "magnifyingglass"
    case folder             = "folder"
    case calendar           = "calendar"
    case text               = "text.alignleft"
    case background         = "rectangle.tophalf.inset.filled"
    case screenshot         = "rectangle.on.rectangle.angled"
    case screenshotAlt      = "squares.below.rectangle"
    case edit               = "square.and.pencil"
    case blurb              = "quote.bubble"
    case gradient           = "water.waves"
    case copy               = "doc.on.doc"
    case command            = "command"
    case select             = "character.cursor.ibeam"
    case door               = "door.left.hand.open"
    case expand             = "arrow.down.left.and.arrow.up.right"
    case logOut             = "rectangle.portrait.and.arrow.right"
    case token              = "hockey.puck"
    
    
    // APIs
    case igdb           = "igdb"
    case rawg           = "rawg"
    case steamGrid      = "square.3.layers.3d.down.right"
    case steam          = "steam"
    
    // Tags
    case tag            = "tag"
    case rpg            = "text.book.closed"
    case survival       = "backpack"
    case multiplayer    = "person.3"
    case racing         = "flag.checkered"
    case action         = "burst"
    
    var id: Self { self }
    
    var icon: String {
        return self.rawValue
    }
}
