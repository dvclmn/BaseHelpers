//
//  CheckInternetConnection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/9/2025.
//

import Network
import SwiftUI

extension EnvironmentValues {
  @Entry public var isConnectedToInternet: Bool = false
}

@MainActor
@Observable
public final class NetworkMonitor {
  private let networkMonitor = NWPathMonitor()
  private let workerQueue = DispatchQueue(label: "Monitor")

  var isConnected = false

  init() {
    networkMonitor.pathUpdateHandler = { path in
      Task { @MainActor in
        self.isConnected = path.status == .satisfied
      }
    }
    networkMonitor.start(queue: workerQueue)
  }
}

public struct NetworkConnectionModifier: ViewModifier {

  @State private var monitor: NetworkMonitor = .init()

  public func body(content: Content) -> some View {
    content
      .environment(\.isConnectedToInternet, monitor.isConnected)
  }
}
extension View {
  public func monitorNetworkConnection() -> some View {
    self.modifier(NetworkConnectionModifier())
  }
}
