//
//  SparkleSetup.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/5/2025.
//

import SwiftUI
import Sparkle

/// https://sparkle-project.org/documentation/programmatic-setup/

/// This view model class publishes when new updates can be checked by the user
public final class CheckForUpdatesViewModel: ObservableObject {
  @Published var canCheckForUpdates = false
  
  init(updater: SPUUpdater) {
    updater.publisher(for: \.canCheckForUpdates)
      .assign(to: &$canCheckForUpdates)
  }
}

/// This is the view for the Check for Updates menu item
/// Note this intermediate view is necessary for the disabled state on the
/// menu item to work properly before Monterey.
///
/// See below for more info:
/// https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug
public struct CheckForUpdatesView: View {
  @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
  private let updater: SPUUpdater
  
  public init(updater: SPUUpdater) {
    self.updater = updater
    
    /// Create our view model for our CheckForUpdatesView
    self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
  }
  
  public var body: some View {
    Button("Check for Updates…", action: updater.checkForUpdates)
      .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
  }
}

/// Usage:
///
/// ```
/// @main
/// struct MyApp: App {
///   private let updaterController: SPUStandardUpdaterController
///
///   init() {
///     updaterController = SPUStandardUpdaterController(
///       startingUpdater: true,
///       updaterDelegate: nil,
///       userDriverDelegate: nil
///     )
///   }
///
///   var body: some Scene {
///     WindowGroup {
///     }
///     .commands {
///       CommandGroup(after: .appInfo) {
///         CheckForUpdatesView(updater: updaterController.updater)
///       }
///     }
///   }
/// }
/// ```
/// And for `MenuCommands`:
/// ```
/// struct MenuCommands: Commands {
///
///   let updaterController: SPUStandardUpdaterController
///   @Bindable var store: AppHandler
///
///   var body: some Commands {
///
///     CommandGroup(after: .appInfo) {
///       CheckForUpdatesView(updater: updaterController.updater)
///     }
///   // etc...
/// ```
