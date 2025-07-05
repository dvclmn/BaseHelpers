//
//  Model+ImportError.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import Foundation

public enum ImportError: Error, CustomStringConvertible {
  case resourceNotFound(String)
  case failedToRead(String)
  case fileExtensionMissing
  case decodingFailed(Error)
  
  public var description: String {
    switch self {
      case .resourceNotFound(let path):
        return "Resource not found at path: \(path)"
      case .failedToRead(let reason):
        return "Failed to read file: \(reason)"
      case .fileExtensionMissing:
        return "File extension missing. Please specify a valid file type."
      case .decodingFailed(let error):
        return "Failed to decode data: \(error)"
    }
  }
}
