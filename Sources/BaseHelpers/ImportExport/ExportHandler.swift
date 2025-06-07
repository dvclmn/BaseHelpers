//
//  ExportHandler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 7/6/2025.
//

import Foundation

public struct ExportHandler {
  
  public static func saveDataToAppSupport(
    named fileName: String,
    data: Data
  ) throws {
    let url: URL = .applicationSupportDirectory
    try data.write(to: url)
//    try data.write(to: fileURL)
  }
}
