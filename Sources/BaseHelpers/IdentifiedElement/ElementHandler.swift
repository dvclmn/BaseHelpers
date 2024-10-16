//
//  ElementHandler.swift
//  Collection
//
//  Created by Dave Coleman on 16/10/2024.
//

import ComposableArchitecture
import Foundation
import Grainient

public protocol SplitViewData: Equatable, Sendable {

  associatedtype Element: IdentifiedElement where Element.ID: Sendable
  
  var elements: IdentifiedArrayOf<Element> { get set }
  var selectedIDs: Set<Element.ID> { get set }
  var currentID: Element.ID? { get set }
  var lastViewedID: Shared<Element.ID>? { get set }
  var toDelete: [Element.ID] { get set }
  
  static var typeDisplayName: String { get }
  
  func newElement() -> Element
}

extension SplitViewData {
  
  func newElement() -> Element {
    let newElement = Element(
      name: nameForNewElement(),
      grainientSeed: GrainientSettings.generateGradientSeed()
    )
    
    return newElement
  }

  func nameForNewElement() -> String {
    let defaultName = "New \(Self.typeDisplayName)"
    
    /// This looks for any existing elements that share the same
    /// default name, so we can appropriately increment the counter
    let duplicateCount = self.elements
      .filter { $0.name.starts(with: defaultName) }
      .count
    
    var leadingZeroIfRequired: String {
      if duplicateCount > 0 && duplicateCount < 9 {
        "0"
      } else {
        ""
      }
    }
    
    let newName = "New conversation" + (duplicateCount > 0 ? " \(leadingZeroIfRequired)\(duplicateCount + 1)" : "")

    return newName
  } // END new name
  
}



//public protocol SplitViewElement: Equatable, Sendable {
//  
//  associatedtype Element: IdentifiedElement
//  
//  
//}


public struct SplitViewHandler<Data: SplitViewData>: Reducer, Sendable {
  
  public typealias ElementID = Data.Element.ID
  
//  enum ToDelete: Equatable, Sendable, Identifiable {
//    case single(Data.Element.ID)
//    case multiple([Data.Element.ID])
//    
//    var id: UUID {
//      switch self {
//        case .single(let id):
//          return id as? UUID
//        case .multiple(let ids):
//          
//          return ids
////          let idString = ids.map { $0.uuidString }.joined()
////          return UUID(uuidString: idString) ?? UUID()
//          
//      }
//    }
//  }
  
  public enum DeleteResult: Sendable {
    case success(count: Int)
    case failure(ids: [ElementID])
  }
  
  public enum Action: BindableAction, Sendable {
    case addNew
    
    case generateNewGrainient
    case updateGrainient(seed: Int)
    
    case loadPrevious
    case deselectElement
    case elementTapped(
      id: ElementID
    )
    case binding(BindingAction<Data>)
    
    case proposeDelete([ElementID])
    case confirmDelete
    case cancelDelete
    case deleteResult(DeleteResult)
    
  }
  
  public init() {}
  
  /// At first I didn't understand why the compiler wasn't complaining that I haven't
  /// more explicitly defined `State`, for `SplitViewHandler`. But when looking
  /// at how the `Reducer` protocol is set up, it is actually looking for
  ///
  /// ```
  /// func reduce(into state: inout State, action: Action) -> Effect<Action>
  /// ```
  ///
  /// I guess that is how we can have a generic Reducer, where the generic constraint
  /// *is* the State? I don't really know, but it works.
  ///
  public func reduce(into state: inout Data, action: Action) -> Effect<Action> {
    switch action {

      case .addNew:
        let newElement = state.newElement()
        state.elements.append(newElement)
        return .send(.elementTapped(id: newElement.id))
        
      case .loadPrevious:
        guard let id = state.lastViewedID else {
          return .none
        }
        guard let element = state.elements[id: id.wrappedValue] else {
          return .none
        }
        return self.loadElement(state: &state, element: element)
        
        
      case .deselectElement:
        state.currentID = nil
        return .none
        
      case .elementTapped(id: let id):
//        if modifiers.contains(.command) {
//          
//          if state.selectedConversationIDs.contains(conversationID) {
//            state.selectedConversationIDs.remove(conversationID)
//            
//          } else {
//            state.selectedConversationIDs.insert(conversationID)
//          }
//          
//          return .none
//          
//        } else if modifiers.isEmpty {
//          
//        } else {
//          return .none
//        }
        state.selectedIDs = []
        
        if let element = state.elements[id: id] {
          print("Should be about to load conversation with name '\(element.name)'")
          return self.loadElement(state: &state, element: element)
        } else {
          print("\(Data.typeDisplayName) wasn't found in the list.")
          return .none
        }

      case .proposeDelete(let ids):
        /// The aim is, that by simply populating this enum, the sheet will present
//        if ids.count == 1, let id = ids.first {
//          state.toDelete = .single(id)
//        } else {
//          state.toDelete = .multiple(ids)
//        }
        
        state.toDelete = ids
        
        return .none
        
        
        
      case .cancelDelete:
        state.toDelete = []
        return .none
        
        
        
      case .confirmDelete:
        
        print("Confirming deletion of conversation(s).")
        
        guard !state.toDelete.isEmpty else {
          print("No conversations marked for deletion.")
          return .none
        }
        
        let result: DeleteResult
        result = self.deleteElements(state: &state, state.toDelete)
//        switch toDelete {
//          case .single(let id):
//          case .multiple(let ids):
//            result = deleteConversations(state: &state, ids)
//        }
        
        state.toDelete = []
        
        return .send(.deleteResult(result))
        
        
      case .deleteResult(let result):
        switch result {
          case .success(let count):
            let message = pluralise(count, "Conversation", includeCount: true)
            print("Delete was a success, deleted \(message)")
            return .none
          case .failure(let ids):
            print("These ids failed to delete: \(ids)")
            return .none
        }
        
        
        
        
        
      case .generateNewGrainient:
        let newSeed: Int = GrainientSettings.generateGradientSeed()
        return self.updateGrainientSeed(state: &state, seed: newSeed)
        
      case .updateGrainient(let seed):
        return self.updateGrainientSeed(state: &state, seed: seed)
        
        
      case .binding:
        return .none
    }
  }
}

extension SplitViewHandler {
  
  func updateGrainientSeed(state: inout State, seed: Int) -> Effect<Action> {
    
    if let elementID = state.currentID {
      state.elements[id: elementID]?.grainientSeed = seed
    }
    
    return .none
  } // END update grainient
  
  
  
  func loadElement(
    state: inout State,
    element: Data.Element
  ) -> Effect<Action> {
    
    guard !element.isDeleted else {
      print("Shouldn't load a \(Self.State.typeDisplayName) that has been deleted.")
      return .none
    }
    
    /// Update the conversation ID, to be persisted to User Defaults
    state.lastViewedID = Shared<ElementID>(element.id)
    
    /// Ensure the conversation is set to be selected
    state.selectedIDs = [element.id]
    
    state.currentID = element.id
    
    return .none
  } // END load element
  
  
  func deleteElements(
    state: inout State,
    _ ids: [ElementID]
  ) -> DeleteResult {
    var deletedCount = 0
    var failedDeletions: [ElementID] = []
    
    /// If the current conversation is among those to be deleted, let's make sure
    /// we reset that property, so it doesn't continue to be displayed after deletion.
//    if let currentID = state.current?.id, ids.contains(currentID) {
//      state.current = nil
//    }
//    
    /// Let's also ensure a deleted conversation is not still selected, after deletion
    state.selectedIDs.subtract(ids)
    
    for id in ids {
      if var element = state.elements[id: id] {
        element.dateDeleted = Date.now
        state.elements[id: id] = element
        deletedCount += 1
        print("Successfully marked '\(element.name)' as deleted.")
      } else {
        failedDeletions.append(id)
        print("Failed to find conversation with ID: \(id)")
      }
    }
    
    if failedDeletions.isEmpty {
      return .success(count: deletedCount)
    } else {
      return .failure(ids: failedDeletions)
    }
    
  }
}
