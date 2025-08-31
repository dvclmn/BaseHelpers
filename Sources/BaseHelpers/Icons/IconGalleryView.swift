//
//  IconGalleryView.swift
//  BaseStyles
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

enum IconType {
  case native
  case custom
}

public struct IconGalleryView: View {

  private let thumbnailSize: CGFloat = 90
  //  @State private var thumbnailSize: IconThumbnailSize = .wide

  let columns: [GridItem] = [GridItem(.flexible())]
  @State private var iconType: IconType = .custom

  let altIconSquareSize: CGFloat = 24

  public var body: some View {

    ScrollView {
      LazyVGrid(
        columns: [
          GridItem(
            .adaptive(minimum: thumbnailSize, maximum: .infinity),
            spacing: Styles.sizeSmall
          )
        ],
        //        columns: columns,
        spacing: Styles.sizeRegular
      ) {
        ForEach(icons, id: \.reference) { icon in
          //        ForEach(Icons.allCases.reversed()) { icon in
          VStack(spacing: 0) {
            MainText(icon.reference)
              .overlay {
                MainIcon(icon.reference)
              }
            //            AltIcons(icon)
          }
          .frame(width: thumbnailSize, height: thumbnailSize)
          .aspectRatio(1 / 1, contentMode: .fill)
          .fixedSize()
          .background(.gray.quinary.opacity(0.7))
          .clipShape(.rect(cornerRadius: Styles.sizeTiny))

        }
      }
      .padding(Styles.sizeMedium)
      //      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .frame(minWidth: 400, minHeight: 600)
  }
}
extension IconGalleryView {

  @ViewBuilder
  func MainIcon(_ iconString: String) -> some View {

    Group {
      switch iconType {
        case .native:
          Image(systemName: iconString)

        case .custom:
          Image(ImageResource(name: iconString, bundle: .module))

      }
    }
    .symbolRenderingMode(.hierarchical)
    .symbolVariant(.fill)
    .font(.system(size: 34))
    .foregroundStyle(.primary.opacity(0.9))
    .padding(.bottom, Styles.sizeRegular)
  }

  @ViewBuilder
  func MainText(_ iconString: String) -> some View {

    VStack(alignment: .leading, spacing: Styles.sizeMicro) {
      Spacer()
      Text(iconString.capitalized)
        .lineLimit(1)
        .fontWeight(.medium)
      //          .font(.callout.weight(.medium))

      //      Text(icon.reference)
      //        .lineLimit(1)
      //        .font(.callout)
      //        .foregroundStyle(.tertiary)
    }
    .padding(Styles.sizeSmall)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
  }

  //  @ViewBuilder
  //  func AltIcons(_ icon: IconsInUse) -> some View {
  //
  //  }
}
extension IconGalleryView {
  var icons: [any IconGalleryViewable] {
    switch iconType {
      case .native:
        return Icons.allCases
      case .custom:
        return CustomSymbol.allCases
    }
  }
}

#if DEBUG
#Preview {
  IconGalleryView()
    .frame(width: 700, height: 700)
}
#endif
