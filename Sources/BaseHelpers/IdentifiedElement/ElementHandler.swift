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
  var lastViewed: Shared<Element.ID>? { get set }
  static var typeDisplayName: String { get }
  
}

extension SplitViewData {
  
  func newElement(name: String) -> Element {
    let newElement = Element(
      name: name,
      grainientSeed: GrainientSettings.generateGradientSeed()
    )
    
    return newElement
  }

  static func nameForNewElement(duplicateCount: Int) -> String {
    let defaultName = "New \(self.typeDisplayName)"

  }
}

@Reducer
public struct SplitViewHandler<Data: SplitViewData> {
  
  public init() {}
  
  public enum DeleteResult: Sendable {
    case success(count: Int)
    case failure(ids: [Data.Element.ID])
  }
  
  @ObservableState
  struct State: Equatable, Sendable {
    var elements: Data.Element
  }
  
  enum Action: BindableAction {
    
    case addNew
    
    case generateNewGrainient
    case updateGrainient(seed: Int)
    
    case loadPrevious
    case deselectElement
    case elementTapped(
      id: Data.Element.ID
    )
    
    case proposeDelete([Data.Element.ID])
    case confirmDelete
    case cancelDelete
    case deleteResult(DeleteResult)
    case binding(BindingAction<State>)
  }
  
  var body: some ReducerOf<Self> {
    
    BindingReducer()
    Reduce<State, Action> { state, action in
      
      switch action {
        case .addNew:
          let newName: String = Data.nameForNewElement(<#T##self: SplitViewData##SplitViewData#>)
          
          
        case .loadPrevious:
          <#code#>
        case .deselectElement:
          <#code#>
        case .elementTapped(id: let id):
          <#code#>
        case .binding(_):
          <#code#>
        case .proposeDelete(_):
          <#code#>
        case .confirmDelete:
          <#code#>
        case .cancelDelete:
          <#code#>
        case .deleteResult(_):
          <#code#>
      }
      
    }
  }
  
}




  
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
  
