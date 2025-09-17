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

    print("Let's try to generate a thumbnail")

    //    do {
    guard let imageURL = await self.downloadImageToDisk(from: url) else {
      print("Couldn't download the image and save it to disk")
      return nil
    }

    let size: CGSize = CGSize(width: 100, height: 100)
    let scale = NSScreen.main?.backingScaleFactor ?? 1
    
    print("The size is \(size) and the scale is \(scale)")

    // Create the thumbnail request.
    let request = QLThumbnailGenerator.Request(
      fileAt: imageURL,
      size: size,
      scale: scale,
      representationTypes: .thumbnail
    )
    
    print("Thumbnail request is made")

    // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
    let generator = QLThumbnailGenerator.shared
    
    print("Generator created: `QLThumbnailGenerator.shared`")
    
    var thumbnailResult: Thumbnail?
    generator.generateRepresentations(for: request) { (thumbnail, type, error) in
      
      DispatchQueue.main.async {
        if let thumb = thumbnail {
          let x = Thumbnail(
            thumbnail: thumb.cgImage,
            fileURL: imageURL
//            resource: resource,
//            ext: ext
          )
          thumbnailResult = x
//          self.sourceImages.append(x)
        }
      }
      
      
      
//      Task { @MainActor in
//        if let thumbnail {
//          thumbnailResult = Thumbnail(
//            thumbnail: thumbnail.cgImage,
//            fileURL: url
//              //            name:
//              //            resource: resource,
//              //            ext: ext
//          )
//          //          self.sourceImages.append(x)
//        }

//      }  // END task
      //      DispatchQueue.main.async {
      //      }
    }  // END generator
    return thumbnailResult

    //    } catch {
    //      print("Could not generate thumbnail: \(error)")
    //      return nil
    //    }

  }

  private static func downloadImageToDisk(from webURL: URL) async -> URL? {
    print("Let's download an image from the web, at url `\(webURL)`")

    do {
      let (data, _) = try await URLSession.shared.data(from: webURL)
      let fileManager = FileManager.default
      let appSupportURL = try fileManager.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
      let fileName = webURL.lastPathComponent
      print("The image file name will be `\(fileName)`")
      let savedURL = appSupportURL.appendingPathComponent(fileName)
      print("The url we'll save to is `\(savedURL)`")
      try data.write(to: savedURL)
      return savedURL

    } catch {
      print("Error downloading a web image: \(error)")
      return nil
    }
  }

}
