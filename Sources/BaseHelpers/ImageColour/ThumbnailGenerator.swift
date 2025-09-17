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
public struct ThumbnailGenerator {
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

  public static func thumbnailCGImageFromURL(
    _ url: URL,
    maxPixelSize: Int
  ) -> CGImage? {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
    let options =
      [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
      ] as CFDictionary
    return CGImageSourceCreateThumbnailAtIndex(source, 0, options)
  }

  public static func cgImageFromURL(_ url: URL) -> CGImage? {
    guard let nsImage = NSImage(contentsOf: url) else { return nil }
    var rect = CGRect(origin: .zero, size: nsImage.size)
    return nsImage.cgImage(forProposedRect: &rect, context: nil, hints: nil)
  }
}
