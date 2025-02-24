//
//  Documentable.swift
//  Collection
//
//  Created by Dave Coleman on 17/11/2024.
//

#if canImport(AppKit)
  import SwiftUI

  public protocol Documentable: Sendable, Codable, Equatable, Hashable {}

    extension EnvironmentValues {
      @Entry public var documentCount: DocumentMonitor = .init()
    }


  @Observable
  public final class DocumentMonitor: Sendable {

    public var count: Int = 0

    nonisolated public init() {
      updateCount()
    }

    public var multipleOpen: Bool {
      count > 1
    }
    
    private func updateCount() {
      self.count = NSDocumentController.shared.documents.count
    }
  }
#endif
