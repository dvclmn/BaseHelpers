//
//  Ranges.swift
//  TextCore
//
//  Created by Dave Coleman on 31/8/2024.
//

import Foundation

/// The attributed range as described below, pairs with the `ThreePartRegex` above,
/// and provides a mechism through which to identify where in the
/// `AttributedString` the resulting matches are located.
///
public typealias AttributedRange = Range<AttributedString.Index>

public typealias ThreePartRange = (AttributedRange, AttributedRange, AttributedRange)

public typealias CharacterGrid = [[Character]]

/// The first `Substring` is reserved for the full match. The subsequent three can be used
/// in whatever way makes sense. E.g. for content surrounded by syntax, such as `*italics*`.
///
/// In that example, substrings 2, 3 and 4 would hold the leading asterisk, text content,
/// and trailing asterisk respectively.
///
public typealias ThreePartRegex = Regex<(Substring, Substring, Substring, Substring)>
