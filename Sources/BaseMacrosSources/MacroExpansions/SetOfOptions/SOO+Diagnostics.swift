//
//  SOO+Diagnostics.swift
//  BaseMacros
//
//  Created by Dave Coleman on 18/9/2025.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


enum SetOfOptionsMacroDiagnostic {
  case requiresStruct
  case requiresStringLiteral(String)
  case requiresOptionsEnum(String)
  case requiresOptionsEnumRawType
}

extension SetOfOptionsMacroDiagnostic: DiagnosticMessage {
  func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
    Diagnostic(node: Syntax(node), message: self)
  }
  
  var message: String {
    switch self {
      case .requiresStruct:
        return "'SetOfOptions' macro can only be applied to a struct"
        
      case .requiresStringLiteral(let name):
        return "'SetOfOptions' macro argument \(name) must be a string literal"
        
      case .requiresOptionsEnum(let name):
        return "'SetOfOptions' macro requires nested options enum '\(name)'"
        
      case .requiresOptionsEnumRawType:
        return "'SetOfOptions' macro requires a raw type"
    }
  }
  
  var severity: DiagnosticSeverity { .error }
  
  var diagnosticID: MessageID {
    MessageID(domain: "Swift", id: "SetOfOptions.\(self)")
  }
}

/// The label used for the SetOfOptions macro argument that provides the name of
/// the nested options enum.
let optionsEnumNameArgumentLabel = "optionsName"

/// The default name used for the nested "Options" enum. This should
/// eventually be overridable.
let defaultOptionsEnumName = "Options"

