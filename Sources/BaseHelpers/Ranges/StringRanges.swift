//
//  File.swift
//  
//
//  Created by Dave Coleman on 26/5/2024.
//

import Foundation

/// This extension seems to drive something like the below (as found in Banksia, to highlight search terms)
/*
 
 var match: [String] {
     return [conv.searchText].filter { message.content.localizedCaseInsensitiveContains($0) }
 }
 
 var highlighted: AttributedString {
     var result = AttributedString(message.content)
     _ = match.map {
         let ranges = message.content.ranges(of: $0, options: [.caseInsensitive])
         ranges.forEach { range in
             result[range].backgroundColor = .orange.opacity(0.2)
         }
     }
     return result
 }
 
 */

public extension StringProtocol {

    func ranges<T: StringProtocol>(
        of stringToFind: T,
        options: String.CompareOptions = [],
        locale: Locale? = nil
    ) -> [Range<AttributedString.Index>] {

        var ranges: [Range<String.Index>] = []
        var attributedRanges: [Range<AttributedString.Index>] = []
        let attributedString = AttributedString(self)

        while let result = range(
            of: stringToFind,
            options: options,
            range: (ranges.last?.upperBound ?? startIndex)..<endIndex,
            locale: locale
        ) {
            ranges.append(result)
            let start = AttributedString.Index(result.lowerBound, within: attributedString)!
            let end = AttributedString.Index(result.upperBound, within: attributedString)!
            attributedRanges.append(start..<end)
        }
        return attributedRanges
    }
}
