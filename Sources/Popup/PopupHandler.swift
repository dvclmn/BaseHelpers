//
//  PopupHandler.swift
//  Eucalypt
//
//  Created by Dave Coleman on 24/3/2024.
//

import Foundation
import SwiftUI
import Dependencies



// MARK: - TCA Dependancy value
public extension DependencyValues {
  var popup: PopupHandler {
    get { self[PopupHandler.self] }
    set { self[PopupHandler.self] = newValue }
  }
}
extension PopupHandler: DependencyKey {
  @MainActor public static let liveValue = PopupHandler()
}

// MARK: - Location
public enum PopupLocation: Sendable, Equatable {
  case main
  case systemSettings
  case custom(String)
  
  public var id: String {
    switch self {
      case .main:
        "main"
        
      case .systemSettings:
        "system-settings"
        
      case .custom(let string):
        string
    }
  }
  
}


public protocol Popupable: Sendable {
  func showPopup(title: String, message: String?, location: PopupLocation) async
}

@MainActor
public struct PopupMessage {
  
  public var isLoading: Bool
  public var title: String
  public var message: String?
  public var location: PopupLocation
}

@MainActor
@Observable
public class PopupHandler: Popupable {
  
  var popupMessage: PopupMessage? = nil
  
  public init(
    message: PopupMessage? = nil
    //        popupTask: Task<Void, Never>? = nil
  ) {
    self.popupMessage = message
    //        self.popupTask = popupTask
  }
  
  private var popupTask: Task<Void, Never>? = nil
  
  public func showPopup(
    title: String,
    message: String? = nil,
    location: PopupLocation = .main
  ) {
    let popupMessage = PopupMessage(
      isLoading: false,
      title: title,
      message: message,
      location: location
    )
    Task {
      await showAndHidePopup(popupMessage: popupMessage)
    }
  }
  
  private func showAndHidePopup(popupMessage: PopupMessage) async {
    popupTask?.cancel()
    print("Popup triggered: \(popupMessage.title)")
    
    popupTask = Task {
      await displayPopup(popupMessage: popupMessage)
      
      do {
        try await Task.sleep(for: .seconds(3.5))
        
      } catch {
        print("Couldn't sleep task for popup: \(error)")
        return
      }
      
      await hidePopup()
    }
  } // END show hide popup
  
  private func displayPopup(popupMessage: PopupMessage) async {
    await MainActor.run {
      withAnimation(.easeOut(duration: 0.1)) {
        self.popupMessage = popupMessage
      }
    }
  }
  
  private func hidePopup() async {
    await MainActor.run {
      withAnimation(.easeInOut(duration: 0.6)) {
        self.popupMessage = nil
      }
    }
  }
}
