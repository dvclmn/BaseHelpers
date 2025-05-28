//
//  ImportingHandler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/5/2025.
//

import Foundation

public enum ImportError: Error, LocalizedError {
  case fileNotFound
  case invalidFormat
  case resourcePathNotFound
  

  public var errorDescription: String {
    switch self {
      case .fileNotFound:
        return "File not found"
        
      case .invalidFormat:
        return "Invalid file format"
        
      case .resourcePathNotFound:
        return "Resource path not found"
    }
  }
}

/// This should probably be a collection of useful methods (static?),
/// leaving the seperate apps to convert raw data to their domain models
public struct ImportHandler {

  static func loadFromResourcesBundle(fileName: String) throws -> String {
    guard let url = Bundle.main.resourcePath else {
      print("Bundle resource path not found")
      throw ImportError.resourcePathNotFound
    }
    let resource = url + "/\(fileName).txt"
    return try loadStringFromFile(filePath: resource)

  }
  
  static func loadStringFromFile(filePath: String) throws -> String {
    do {
      let content = try String(contentsOfFile: filePath)
      return content
    } catch {
      print("Error reading file '\(filePath)': \(error)")
      throw ImportError.fileNotFound
    }
  }

}
