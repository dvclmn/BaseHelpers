//
//  ExportHandler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 7/6/2025.
//

import Foundation

public struct ExportHandler {
  
//  public static func saveDataToAppSupport(
//    named fileName: String,
//    data: Data
//  ) throws {
//    let url: URL = .applicationSupportDirectory
//    try data.write(to: url)
////    try data.write(to: fileURL)
//  }
  
  public static func saveDataToAppSupport(
    named fileName: String,
    data: Data
  ) throws {
    /// 1. Get Application Support directory
    let directoryURL = FileManager.default.urls(
      for: .applicationSupportDirectory,
      in: .userDomainMask
    ).first!
    
    /// 2. Optionally create the directory if it doesn't exist
    try FileManager.default.createDirectory(
      at: directoryURL,
      withIntermediateDirectories: true,
      attributes: nil
    )
    
    /// 3. Append filename
    let fileURL = directoryURL.appendingPathComponent(fileName)
    
    /// 4. Write data
    try data.write(to: fileURL)
  }
}
