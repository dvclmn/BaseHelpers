//
//  File.swift
//
//
//  Created by Dave Coleman on 8/7/2024.
//

import Foundation
import SwiftUI

#if os(macOS)

  public struct SheetFrame: ViewModifier {

    let minWidth: CGFloat
    let maxWidth: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    //    let presentatingSizing: PresentationSizing

    public func body(content: Content) -> some View {


      if #available(macOS 15, iOS 18, *) {

        content
          .presentationSizing(.fitted)
          .modifier(
            FrameModifier(
              minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight))

      } else {
        content
          .modifier(
            FrameModifier(
              minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight))
      }
    }

  }

  public struct FrameModifier: ViewModifier {

    let minWidth: CGFloat
    let maxWidth: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    public func body(content: Content) -> some View {
      content
        .frame(
          minWidth: minWidth,
          idealWidth: (minWidth + maxWidth) / 2,
          maxWidth: maxWidth,
          minHeight: minHeight,
          idealHeight: (minHeight + maxHeight) / 2,
          maxHeight: maxHeight
        )
    }
  }

  extension View {

    /// Example use:
    /// ```
    /// // Specifying width
    /// someView.sheetFrame(2/3, width: 400)  // Portrait orientation (2:3)
    /// someView.sheetFrame(16/9, width: 500)  // Landscape orientation (16:9)
    ///
    /// // Specifying height
    /// someView.sheetFrame(2/3, height: 600)  // Portrait orientation (2:3)
    /// someView.sheetFrame(16/9, height: 300)  // Landscape orientation (16:9)
    ///
    /// ```
    /// Sets up a frame with a specific aspect ratio and width
    /// - Parameters:
    ///   - aspectRatio: The desired aspect ratio (width/height). For example, 2/3 represents a portrait orientation.
    ///   - width: The desired width. This will be used to calculate the appropriate height.
    ///   - minWidth: The minimum allowed width. Defaults to 340.
    ///   - maxWidth: The maximum allowed width. Defaults to 680.
    public func sheetFrame(
      _ aspectRatio: CGFloat,
      width: CGFloat,
      minWidth: CGFloat = 340,
      maxWidth: CGFloat = 680
    ) -> some View {
      let height = width / aspectRatio
      return self.modifier(
        SheetFrame(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: height * (minWidth / width),
          maxHeight: height * (maxWidth / width)
        )
      )
    }

    /// Sets up a frame with a specific aspect ratio and height
    /// - Parameters:
    ///   - aspectRatio: The desired aspect ratio (width/height). For example, 2/3 represents a portrait orientation.
    ///   - height: The desired height. This will be used to calculate the appropriate width.
    ///   - minHeight: The minimum allowed height. Defaults to 400.
    ///   - maxHeight: The maximum allowed height. Defaults to 960.
    public func sheetFrame(
      _ aspectRatio: CGFloat,
      height: CGFloat,
      minHeight: CGFloat = 400,
      maxHeight: CGFloat = 960
    ) -> some View {
      let width = height * aspectRatio
      return self.modifier(
        SheetFrame(
          minWidth: width * (minHeight / height),
          maxWidth: width * (maxHeight / height),
          minHeight: minHeight,
          maxHeight: maxHeight
        )
      )
    }

    public func sheetFrame(
      minWidth: CGFloat = 340,
      maxWidth: CGFloat = 680,
      minHeight: CGFloat = 400,
      maxHeight: CGFloat = 960
    ) -> some View {
      self.modifier(
        SheetFrame(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight
        )
      )
    }
  }

#endif
