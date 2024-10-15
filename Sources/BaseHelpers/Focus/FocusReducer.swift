//
//  FocusModifier.swift
//  Collection
//
//  Created by Dave Coleman on 14/10/2024.
//

import SwiftUI
import ComposableArchitecture


//
//@Reducer
//public struct Focus<Item: FocusableItem> {
//  
//  @ObservableState
//  public struct State: Equatable, Sendable {
//    
//    var focusedElement: Item?
//    
//    public init(
//      focusedElement: Item? = nil
//    ) {
//      self.focusedElement = focusedElement
//    }
//  }
//  
//  public enum Action: BindableAction {
//    case binding(BindingAction<State>)
//  }
//  
//  public var body: some ReducerOf<Self> {
//    
//    BindingReducer()
//    Reduce { state, action in
//      
//      switch action {
//        case .binding:
//          return .none
//      }
//      
//    }
//    //    ._printChanges()
//  }
//  
//}
