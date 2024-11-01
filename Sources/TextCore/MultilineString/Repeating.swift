//
//  Repeating.swift
//  TextCore
//
//  Created by Dave Coleman on 14/9/2024.
//



public extension MultilineString {
  
  func repeatHorizontally(
    toWidth width: Int,
    paddingCharacter: Character = " ",
    trimMethod: TrimMethod = .crop // Need to implement this
  ) -> MultilineString {
    
    guard !self.isEmpty else { return MultilineString([]) }
    
    let patternWidth = self.width
    let patternHeight = self.height
    
    let repetitions = width / patternWidth
    let remainder = width % patternWidth
    
    var result = MultilineString([])
    
    for row in 0..<patternHeight {
      var newRow: [Character] = []
      for _ in 0..<repetitions {
        newRow.append(contentsOf: self[row])
      }
      
      if remainder > 0 {
        switch trimMethod {
          case .leaveSpace:
            newRow.append(contentsOf: self[row][0..<remainder])
            newRow.append(contentsOf: Array(repeating: paddingCharacter, count: patternWidth - remainder))
          case .crop:
            newRow.append(contentsOf: self[row][0..<remainder])
        }
      }
      result.append(newRow)
    }
    
    return result
  }
  
}
