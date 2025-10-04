//
//  Configuration.swift
//  BoxCore
//
//  Created by Dave Coleman on 23/8/2024.
//

import BaseHelpers

public extension BoxCore {
  
  /// Defines the appearance and behavior of a `BoxCore`.
  ///
  /// Use `Config` to customize various aspects of a `BoxCore`,
  /// such as its theme, width, and content limitations.
  ///
  ///
  struct Config: Sendable {

    /// The visual theme of the box.
    ///
    public var theme: Theme
    
    /// The width of the box in `Character`s.
    ///
    /// This value determines the overall width of the box, including its borders.
    /// The content will be wrapped to fit within this width.
    ///
    public var width: Int
    
    /// The maximum number of lines for the header.
    ///
    /// If set, the header will be truncated if it exceeds this number of lines.
    /// Set to `nil` for no limit.
    ///
    public var headerLineLimit: Int
    
    /// The maximum number of lines for the main content.
    ///
    /// If set, the content will be truncated if it exceeds this number of lines.
    /// Set to `nil` for no limit.
    ///
    public var contentLineLimit: Int
    
    public var wordWrapStrategy: WordWrapStrategy
    /// Display metadata about the box itself
    ///
    public var metrics: Metrics
    
    public init(
      theme: Theme = Theme(),
      width: Int = 60,
      headerLineLimit: Int = 0,
      contentLineLimit: Int = 0,
      wordWrapStrategy: WordWrapStrategy = .hyphenate,
      metrics: Metrics = Metrics()
    ) {
      self.theme = theme
      self.width = width
      self.headerLineLimit = headerLineLimit
      self.contentLineLimit = contentLineLimit
      self.wordWrapStrategy = wordWrapStrategy
      self.metrics = metrics
    }
    
    /// The default configuration for a `BoxCore`.
    ///
    public static let `default` = Config()
  }

}
