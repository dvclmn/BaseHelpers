//
//  CIImageTest.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//




//import SwiftUI
//import CoreImage
//import UIKit
//
//func averageColor(from image: UIImage) -> UIColor? {
//  let ciImage = CIImage(image: image)
//  let extent = ciImage?.extent ?? .zero
//
//  let parameters: [String: Any] = [kCIInputExtentKey: CIVector(cgRect: extent)]
//  guard let filter = CIFilter(name: "CIAreaAverage", parameters: parameters),
//        let outputImage = filter.outputImage else {
//    return nil
//  }
//  var bitmap = [UInt8](repeating: 0, count: 4)
//  let context = CIContext()
//  context.render(outputImage,
//                 toBitmap: &bitmap,
//                 rowBytes: 4,
//                 bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
//                 format: .RGBA8,
//                 colorSpace: CGColorSpaceCreateDeviceRGB())
//  return UIColor(red: CGFloat(bitmap[0]) / 255,
//                 green: CGFloat(bitmap[1]) / 255,
//                 blue: CGFloat(bitmap[2]) / 255,
//                 alpha: 1)
//}

