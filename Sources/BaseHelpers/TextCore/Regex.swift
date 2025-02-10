//
//  Regex.swift
//  Collection
//
//  Created by Dave Coleman on 10/2/2025.
//

import Foundation

public typealias MarkdownRegex = Regex<
  (
    Substring,
    leading: Substring,
    content: Substring,
    trailing: Substring
  )
>

public typealias MarkdownRegexOutput = Regex<MarkdownRegex>.RegexOutput
public typealias MarkdownRegexMatch = MarkdownRegexOutput.Match
