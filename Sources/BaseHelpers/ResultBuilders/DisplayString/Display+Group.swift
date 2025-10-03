//
//  DisplayGroup.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

//extension DisplayString {
//
//  public struct DisplayGroup {
//
//  }
//}

//extension DisplayPair {
//
//  public var displayString: String {
//    return displayStringStyled.toString
//  }
//
//  public var displayStringStyled: AttributedString {
//    let result = valuePair(self)
//    return result
//  }

//  public func displayString(
//    _ places: DecimalPlaces,
//    separator: String = "x",
//    style: ValueDisplayStyle = .plain,
//    //    hasSpace: Bool = false,
//    grouping: Grouping = .automatic
//  ) -> String {
//
//    let valA: String = valueA.displayString(places, grouping: grouping)
//    let valB: String = valueB.displayString(places, grouping: grouping)
//
//    let result: String
//    switch style {
//      case .labels(let style):
//
//        /// Note the inclusion of intentional spaces after labels in the below
//        switch style {
//          case .abbreviated:
//            result = "\(labelA.abbreviated) \(valA)\(separator)\(labelB.abbreviated) \(valB)"
//          case .full:
//            result = "\(labelA.full) \(valA)\(separator)\(labelB.full) \(valB)"
//        }
//      case .plain:
//        result = "\(valA)\(separator)\(valB)"
//    }
//    return result
//  }
//
//  public func displayStringStyled(
//    _ places: DecimalPlaces = .fractionLength(2),
//    separator: String = "x",
//    style: ValueDisplayStyle = .plain,
//    grouping: Grouping = .automatic
//  ) -> AttributedString {
//
//    let pair = valuePair(self, places: places, separator: separator)
//    return pair
//  }
//}
