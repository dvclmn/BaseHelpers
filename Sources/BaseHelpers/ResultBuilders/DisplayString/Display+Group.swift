//
//  DisplayGroup.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

extension DisplayString {
  
  public struct DisplayGroup {
    let components: [Component<>]
    let separator: String
    
    public init(separator: String = " × ", @DisplayBuilder _ components: () -> [DisplayComponent]) {
      self.components = components()
      self.separator = separator
    }
    
    public init(components: [DisplayComponent], separator: String = " × ") {
      self.components = components
      self.separator = separator
    }
  }
}
