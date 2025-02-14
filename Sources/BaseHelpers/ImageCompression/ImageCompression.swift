//
//  ImageCompression.swift
//  Eucalypt
//
//  Created by Dave Coleman on 24/3/2024.
//

import Foundation

// TODO: This only handle macOS, so I will need to handle iOS too
#if canImport(AppKit)
  import AppKit

  extension Data {
    func resizedImage(maxDimension: CGFloat, compression: Double = 0.5) -> Data? {
      guard let image = NSImage(data: self) else { return nil }

      var newSize: CGSize
      let aspectRatio = image.size.width / image.size.height

      if image.size.width > image.size.height {
        newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
      } else {
        newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
      }

      let newImage = NSImage(size: newSize)
      newImage.lockFocus()
      image.draw(in: NSRect(origin: .zero, size: newSize))
      newImage.unlockFocus()

      guard let tiffData = newImage.tiffRepresentation,
        let bitmapImage = NSBitmapImageRep(data: tiffData)
      else {
        return nil
      }

      let jpegData = bitmapImage.representation(
        using: .jpeg, properties: [.compressionFactor: compression])
      return jpegData
    }
  }
#elseif canImport(UIKit)
  import UIKit

  extension Data {
    func resizedImage(maxDimension: CGFloat, compression: Double = 0.5) -> Data? {
      guard let image = UIImage(data: self) else { return nil }

      var newSize: CGSize
      let aspectRatio = image.size.width / image.size.height

      if image.size.width > image.size.height {
        newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
      } else {
        newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
      }

      UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
      image.draw(in: CGRect(origin: .zero, size: newSize))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      let jpegData = newImage?.jpegData(compressionQuality: CGFloat(compression))
      return jpegData
    }
  }
#endif
