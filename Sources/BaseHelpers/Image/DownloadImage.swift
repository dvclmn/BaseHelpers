//
//  DownloadImage.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/9/2025.
//

import Foundation

public enum ImageDownload {
  
  /// Downloads image file from the provided web URL,
  ///  and returns a file path URL
  @discardableResult
  public static func downloadImageToDisk(from webURL: URL?) async -> URL? {
    guard let url = webURL else {
      return nil
    }
    print("Let's download an image from the web, at url `\(url)`")
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let fileManager = FileManager.default
      let appSupportURL = try fileManager.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
      let fileName = url.lastPathComponent
      print("The image file name will be `\(fileName)`")
      
      let savedURL = appSupportURL.appendingPathComponent(fileName)
      print("The url we'll save to is `\(savedURL)`")
      
      try data.write(to: savedURL)
      print("Writing to disk was successful.")
      
      return savedURL
      
    } catch {
      print("Error downloading a web image: \(error)")
      return nil
    }
  }
}
