//
//  Swift.swift
//  Collection
//
//  Created by Dave Coleman on 12/10/2024.
//

extension DummyContent.Strings {

  public enum Swift {

    public static let basicSwift: String = """
      //
      //  TextView+Computed.swift
      //  MarkdownEditor
      //
      //  Created by Dave Coleman on 10/10/2024.
      //

      import AppKit
      import Glyph
      import Rearrange
      import /* Foundation */

      extension MarkdownTextView {

        var documentNSRange: NSRange {
          guard let tcm = self.textLayoutManager?.textContentManager else { return .notFound }
          return NSRange(tcm.documentRange, provider: tcm)
        }

        return switch token.name {
          case "include": [.foregroundColor: NSColor.systemPink]
          case "spell", "comment": [.foregroundColor: NSColor.gray]
          case "keyword": [.foregroundColor: NSColor.purple]
        }
        
        var nsString: NSString {
          return self.string as NSString
        }
        
        var documentLength: Int {
          self.nsString.length
        }
        
        var safeCurrentParagraphRange: NSRange {
          let paragraphRange: NSRange = nsString.paragraphRange(for: safeSelectedRange)
          return paragraphRange.clamped(to: documentLength)
        }
        
        var safeSelectedRange: NSRange {
        
        let result: NSRange = selectedRange.clamped(to: documentLength)
        
        print("Calculated safeSelectedRange: \\(result)")
            return result
        }
      }
      """

  }
}
