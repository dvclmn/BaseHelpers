//
//  ThumbnailGenerator.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import AppKit
import QuickLookThumbnailing
import SwiftUI

@MainActor
struct ThumbnailGenerator {
  
  static func generateThumbnailRepresentation(
    //    forImage: Image
    imageURL url: URL
    //    forResource resource: String,
    //    withExtension ext: String
  ) async -> Thumbnail? {
    
    do {
      let imageURL = try await self.downloadImageToDisk(from: url)
      
      let size: CGSize = CGSize(width: 100, height: 100)
      let scale = NSScreen.main?.backingScaleFactor ?? 1
      
      // Create the thumbnail request.
      let request = QLThumbnailGenerator.Request(
        fileAt: imageURL,
        size: size,
        scale: scale,
        representationTypes: .thumbnail
      )
      
      // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
      let generator = QLThumbnailGenerator.shared
      var thumbnailResult: Thumbnail?
      generator.generateRepresentations(for: request) { (thumbnail, type, error) in
        Task { @MainActor in
          if let thumbnail {
            thumbnailResult = Thumbnail(
              thumbnail: thumbnail.cgImage,
              fileURL: url
              //            name:
              //            resource: resource,
              //            ext: ext
            )
            //          self.sourceImages.append(x)
          }
          
        }  // END task
           //      DispatchQueue.main.async {
           //      }
      }  // END generator
      return thumbnailResult
    } catch {
      return nil
    }
    
  }

  private static func downloadImageToDisk(from webURL: URL) async throws -> URL {
    let (data, _) = try await URLSession.shared.data(from: webURL)
    let fileManager = FileManager.default
    let appSupportURL = try fileManager.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: .cachesDirectory,
      create: true
    )
    let fileName = webURL.lastPathComponent
    let savedURL = appSupportURL.appendingPathComponent(fileName)
    try data.write(to: savedURL)
    return savedURL
  }

  
}
