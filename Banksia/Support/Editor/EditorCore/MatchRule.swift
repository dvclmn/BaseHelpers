//
//  MatchRule.swift
//
//
//  Created by Matthew Davidson on 26/11/19.
//

import Foundation

public class MatchRule: Rule, Pattern {
    
    public let id: UUID
    
    public weak var grammar: Grammar?
    
    let scopeName: ScopeName
    var match: NSRegularExpression
    var captures: [Capture]
    
    public init(
        name: String,
        match: String,
        captures: [Capture] = []
    ) {
        self.id = UUID()
        self.scopeName = ScopeName(rawValue: name)
        do {
            self.match = try NSRegularExpression(pattern: match, options: .init(arrayLiteral: .anchorsMatchLines, .dotMatchesLineSeparators))
        }
        catch {
            fatalError("Could not create regex for MatchRule with name '\(name)' due to error: \(error.localizedDescription)")
        }
        self.captures = captures
    }
    
    public func resolve(parser: Parser, grammar: Grammar) -> [Rule] {
        self.grammar = grammar
        return [self]
    }
}
