//
//  Documentable.swift
//  Collection
//
//  Created by Dave Coleman on 17/11/2024.
//

#if canImport(AppKit)
import SwiftUI

public protocol Documentable: Sendable, Codable, Equatable, Hashable {}

public extension EnvironmentValues {
  @Entry var documentCount: DocumentMonitor = .init()
}


@Observable
public final class DocumentMonitor {
  
  public var count: Int = 0

  public init() {
    updateCount()
  }
  
  public var multipleOpen: Bool {
    count > 1
  }
  private func updateCount() {
//    Task { @MainActor in
    self.count = NSDocumentController.shared.documents.count
//    }
  }
}
#endif

