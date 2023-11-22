//
//  IconHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 21/11/2023.
//

import Foundation

struct ConversationIcon: Hashable {
    
    let name: String
    let favourite: Bool = false
    let category: IconCategory
    let searchTerms: [String]
}

enum IconCategory: String, CaseIterable {
    case general
    case technology
    case nature
    case objects
    case fitness
    case productivity
    case shapes
    case symbols
    case creativity
    case transport
    
    var icon: String {
        switch self {
        case .general:
            return "rays"
        case .technology:
            return "qrcode"
        case .nature:
            return "fish"
        case .objects:
            return "hanger"
        case .fitness:
            return "figure.basketball"
        case .productivity:
            return "paperclip"
        case .shapes:
            return "pentagon"
        case .symbols:
            return "command"
        case .creativity:
            return "theatermasks"
        case .transport:
            return "ferry"
        }
    }
}

extension ConversationIcon {
    
    static let icons: [ConversationIcon] = [
        ConversationIcon(
            name: "pencil",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "scribble.variable",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pencil.and.outline",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "trash",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "folder",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "paperplane",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tray",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "externaldrive",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "archivebox",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "doc",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "apple.terminal",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "calendar",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "book",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "books.vertical",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "book.closed",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bookmark",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "graduationcap",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "ruler",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "backpack",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "paperclip",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "link",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "person",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.arms.open",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.2.arms.open",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.walk",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.basketball",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.skiing.downhill",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.mind.and.body",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "figure.outdoor.cycle",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "dumbbell",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "soccerball.inverse",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "baseball",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "basketball",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "football",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tennis.racket",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tennisball",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "volleyball",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "skateboard",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gym.bag",
            category: .fitness,
            searchTerms: []
        ),

        ConversationIcon(
            name: "rosette",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "trophy",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "medal",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "command",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "power",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "shift",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "rays",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cursorarrow.rays",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "slowmo",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cursorarrow",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cursorarrow.motionlines",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "keyboard",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "peacesign",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "globe",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "globe.europe.africa",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "sun.max",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "zzz",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "moon",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "sparkle",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "sparkles",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cloud",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cloud.bolt",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "smoke",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wind",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "snowflake",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tornado",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "thermometer.medium",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "rainbow",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "water.waves",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "drop",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flame",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "beach.umbrella",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "umbrella",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "play",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "stop",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "playpause",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "backward",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "forward",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "backward.end",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "forward.end",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "shuffle",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "repeat",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "infinity",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "megaphone",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "speaker.wave.2",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "music.note",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "music.quarternote.3",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "music.mic",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gobackward",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "swift",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "magnifyingglass",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mic",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "righttriangle",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.lefthalf.filled.inverse",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "target",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.dotted",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.grid.2x2",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.grid.3x3",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.hexagonpath",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.hexagongrid",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "square.split.2x2",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "square.dashed",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "app.gift",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "rectangle.3.group",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "triangleshape",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "diamond",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "octagon",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pentagon",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "seal",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "heart",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fleuron",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "suit.club",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "suit.diamond",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "suit.spade",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "star",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "shield",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flag",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flag.checkered",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flag.2.crossed",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flag.checkered.2.crossed",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "location",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bell",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tag",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bolt",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flashlight.off.fill",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "camera",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "message",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "ellipsis.message",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bubble",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "quote.opening",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "quote.closing",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "text.bubble",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "phone",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "video",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "field.of.view.wide",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "envelope",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mail.stack",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gear",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gearshape",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gearshape.2",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "signature",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "line.3.crossed.swirl.circle",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "scissors",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bag",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cart",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "basket",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "creditcard",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "giftcard",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wand.and.rays",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wand.and.stars",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "dial.high",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "nosign",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gauge.with.dots.needle.67percent",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "metronome",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "dice",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "die.face.6",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pianokeys",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tuningfork",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "paintbrush",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "paintbrush.pointed",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wrench.adjustable",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hammer",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "screwdriver",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "eyedropper.halffull",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wrench.and.screwdriver",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "applescript",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "scroll",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "stethoscope",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "handbag",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "briefcase",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cross.case",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "theatermasks",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "puzzlepiece.extension",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "puzzlepiece",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "house",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "storefront",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "lightbulb",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fan",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "lamp.desk",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "powerplug",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "powercord",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "door.left.hand.open",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "door.left.hand.closed",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "spigot",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "party.popper",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "balloon.2",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "laser.burst",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fireworks",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "frying.pan",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "popcorn",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bed.double",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chair.lounge",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tent",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "signpost.left",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "signpost.right.and.left",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mountain.2",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "lock",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "lock.open",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "key",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wifi",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pin",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mappin.and.ellipse",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "map",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cpu",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "computermouse",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "watch.analog",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "headphones",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hifispeaker",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cable.coaxial",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "radio",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wave.3.right",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "guitars",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "airplane",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "airplane.departure",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "car",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bus",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tram",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "ferry",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "sailboat",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "truck.box",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bicycle",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "scooter",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "stroller",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fuelpump",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "warninglight",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "glowplug",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "heat.waves",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "oilcan",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "car.side",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "truck.pickup.side",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "road.lanes",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "road.lanes.curved.right",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "horn",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bubbles.and.sparkles.fill",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bandage",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "syringe",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pill",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cross",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "flask",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "staroflife",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hare",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tortoise",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "dog",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cat",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "lizard",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bird",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "ant",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "ladybug",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fish",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pawprint",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "teddybear",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "leaf",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "camera.macro",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tree",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hanger",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "crown",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "tshirt",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "face.smiling",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "face.dashed",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "eye",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "nose",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "comb",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mustache",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mouth",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "eyeglasses",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "sunglasses",
            category: .objects,
            searchTerms: []
        ),

        ConversationIcon(
            name: "brain.filled.head.profile",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "brain",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "ear",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hand.raised.fingers.spread",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hand.thumbsup",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hand.thumbsdown",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hand.point.up.left",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "hands.clap",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "qrcode",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "photo",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "camera.aperture",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "photo.on.rectangle.angled",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "point.bottomleft.forward.to.point.topright.scurvepath",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "slider.vertical.3",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cube",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "shippingbox",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cone",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "pyramid",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "scope",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "helm",
            category: .transport,
            searchTerms: []
        ),

        ConversationIcon(
            name: "clock",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "alarm",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "stopwatch",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chart.xyaxis.line",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "arcade.stick.console",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gamecontroller",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.grid.cross",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "dpad",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "circle.circle",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "playstation.logo",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "xbox.logo",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "paintpalette",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "swatchpalette",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cup.and.saucer",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "mug",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "wineglass",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "birthday.cake",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "carrot",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fork.knife",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cylinder",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "cylinder.split.1x2",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chart.bar",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chart.pie",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chart.line.uptrend.xyaxis",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chart.dots.scatter",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "squareshape.split.2x2",
            category: .shapes,
            searchTerms: []
        ),

        ConversationIcon(
            name: "burst",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "waveform.path.ecg",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "waveform",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "touchid",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "atom",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "compass.drawing",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "globe.desk",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "fossil.shell",
            category: .nature,
            searchTerms: []
        ),

        ConversationIcon(
            name: "gift",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "camera.filters",
            category: .creativity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "grid",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "checklist",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "list.bullet",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "character",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "textformat",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "percent",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "paragraphsign",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "info",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "at",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "exclamationmark.questionmark",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "plus",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "multiply",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "divide",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chevron.left.forwardslash.chevron.right",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "curlybraces",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "number",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "checkmark",
            category: .productivity,
            searchTerms: []
        ),

        ConversationIcon(
            name: "arrow.clockwise",
            category: .technology,
            searchTerms: []
        ),

        ConversationIcon(
            name: "arrow.3.trianglepath",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "arrow.triangle.branch",
            category: .general,
            searchTerms: []
        ),

        ConversationIcon(
            name: "asterisk",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "dollarsign",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "lirasign",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "bitcoinsign",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "chineseyuanrenminbisign",
            category: .symbols,
            searchTerms: []
        ),

        ConversationIcon(
            name: "apple.logo",
            category: .symbols,
            searchTerms: []
        )
    ]
} // END ConversationIcon extension


