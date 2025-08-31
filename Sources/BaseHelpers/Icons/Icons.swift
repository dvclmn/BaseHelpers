//
//  File.swift
//
//
//  Created by Dave Coleman on 25/6/2024.
//

import Foundation

protocol IconGalleryViewable: Identifiable, RawRepresentable, CaseIterable where Self.RawValue == String {
  var id: String { get }
  var reference: String { get }
}

// MARK: - Icons
public enum Icons: String, IconGalleryViewable, Codable, Equatable {
  case stats = "chart.dots.scatter"
  case statsAlt = "chart.pie"
  case refresh = "arrow.triangle.2.circlepath"
  case trash = "trash"
  case controller = "gamecontroller"
  case controllerAlt = "arcade.stick.console"
  case plug = "powerplug"
  case powerCord = "powercord"
  case shocked = "poweroutlet.type.b"
  case powerAU = "poweroutlet.type.i"
  case tap = "spigot"
  case antenna = "antenna.radiowaves.left.and.right"
  case heart = "heart"
  case game = "sdcard"
  case back = "chevron.backward"
  case forward = "chevron.forward"
  case up = "chevron.up"
  case down = "chevron.down"
  case debug = "ladybug"
  case store = "storefront"
  case source = "square.and.arrow.down"
  case sourceAlt = "water.waves.and.arrow.trianglehead.down"
  case person = "person"
  case menu = "line.3.horizontal.decrease"
  case question = "questionmark.circle"
  case questionAlt = "questionmark"
  case thumb = "hand.thumbsup"
  case grid = "rectangle.grid.3x2"
  case gridAlt = "square.grid.2x2"
  case dimensions = "arrow.down.left.and.arrow.up.right.rectangle"  // size, canvas
  case pin = "pin"
  case portrait = "rectangle.portrait"
  case plus = "plus"
  case plusSquare = "plus.app"
  case `import` = "tray.and.arrow.down.fill"
  case warning = "exclamationmark.triangle.fill"
  case share = "square.and.arrow.up"  // export
  case info = "info.circle"
  case inspector = "rectangle.rightthird.inset.filled"
  case popup = "text.bubble"
  case messageAlt = "bubble.middle.bottom"
  case message = "bubble"
  case image = "photo"
  case imageMulti = "photo.on.rectangle.angled"
  case options = "slider.horizontal.3"
  case gear = "gearshape"
  case glasses = "eyeglasses"
  case bookmark = "bookmark"
  case rays = "rays"
  case rotate = "arrow.counterclockwise"
  case window = "macwindow"  // app, viewport
  case pause = "pause"
  case stop = "stop"
  case stopAlt = "octagon"
  case clock = "clock"
  case tick = "checkmark"
  case gift = "gift"
  case giftAlt = "app.gift"
  case eye = "eye"
  case title = "textformat"
  case cloud = "cloud"
  case circle = "circle"
  case binoculars = "binoculars"
  case hashtag = "number"
  case hashtagAlt = "grid"
  case sidebar = "sidebar.left"
  case sidebarAlt = "rectangle.leftthird.inset.filled"
  case list = "square.stack"
  case drag = "line.3.horizontal"
  case library = "books.vertical"
  case trophy = "trophy"
  case globe = "globe.asia.australia"
  case cross = "xmark"
  case crossSquare = "x.square"
  case arrowDown = "arrow.down"
  case swirl = "glowplug"
  case dismissKeyboard = "keyboard.chevron.compact.down"
  case go = "arrow.up.right"
  case sparkle = "sparkles"
  case empty = "light.max"
  case search = "magnifyingglass"  // zoom
  case zoomCircle = "magnifyingglass.circle.fill"
  case pan = "rectangle.and.hand.point.up.left"
  case gesture = "hand.pinch"
  case folder = "folder"
  case escape = "escape"
  case calendar = "calendar"
  case text = "text.alignleft"
  case background = "rectangle.tophalf.inset.filled"
  case screenshot = "rectangle.on.rectangle.angled"
  case screenshotAlt = "squares.below.rectangle"
  case edit = "square.and.pencil"
  case blurb = "quote.bubble"
  case gradient = "water.waves"
  case copy = "square.on.square"
  case copyAlt = "doc.on.doc"
  case command = "command"
  case select = "character.cursor.ibeam"
  case door = "door.left.hand.open"
  case expand = "arrow.down.left.and.arrow.up.right"
  case toolbar = "rectangle.topthird.inset.filled"
  case logOut = "rectangle.portrait.and.arrow.right"
  case developer = "keyboard"
  case token = "hockey.puck"

  case sliders = "switch.2"
  case minus = "minus"
  case qrCode = "qrcode"
  case fish = "fish"
  case hanger = "hanger"
  case sport = "figure.basketball"
  case paperclip = "paperclip"
  case pentagon = "pentagon"
  case theatre = "theatermasks"
  case boat = "ferry"
  case star = "star"
  case ellipsis = "ellipsis"
  case highlighter = "highlighter"
  case key = "key"
  case snowflake = "snowflake"
  case contrast = "circle.lefthalf.striped.horizontal.inverse"
  case horn = "horn"
  case hornBlast = "horn.blast"
  case palette = "paintpalette"
  case plane = "paperplane"
  case lock = "lock"
  case scribble = "scribble.variable"
  case wordCount = "text.word.spacing"  // Character, text, paragraph
  case layers = "square.2.layers.3d"
  case moreLayers = "square.3.layers.3d"
  case cursor = "cursorarrow"  // Pointer
  case character = "character.square"

  // Tags
  case tag = "tag"
  case rpg = "text.book.closed"
  case survival = "backpack"
  case multiplayer = "person.3"
  case racing = "flag.checkered"
  case action = "burst"

  public var id: String { self.rawValue }

  public var icon: String {
    return self.rawValue
  }

  public var reference: String {
    return self.rawValue
  }

  public static var getRandomIcon: String {
    return Icons.allCases.randomElement()?.icon ?? Icons.action.icon
  }
}
