//
//  ImportingHandler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/5/2025.
//

import Foundation

//public enum ImportError: Error, LocalizedError {
//  case fileNotFound
//  case invalidFormat
//  case resourcePathNotFound
//
//
//  public var errorDescription: String {
//    switch self {
//      case .fileNotFound:
//        return "File not found"
//
//      case .invalidFormat:
//        return "Invalid file format"
//
//      case .resourcePathNotFound:
//        return "Resource path not found"
//    }
//  }
//}


public enum ImportError: Error, CustomStringConvertible {
  case resourceNotFound(String)
  case failedToRead(String)
  case fileExtensionMissing
  case decodingFailed(Error)
  
  public var description: String {
    switch self {
      case .resourceNotFound(let path):
        return "Resource not found at path: \(path)"
      case .failedToRead(let reason):
        return "Failed to read file: \(reason)"
      case .fileExtensionMissing:
        return "File extension missing. Please specify a valid file type."
      case .decodingFailed(let error):
        return "Failed to decode data: \(error)"
    }
  }
}

public struct ImportHandler {
  
//  public static func urlForPreviewResource(
//    named resourceName: String,
//    ext: String = "txt"
//  ) -> URL? {
//    return Bundle.main.url(forResource: resourceName, withExtension: ext)
//  }

  /// Load a string from a file at a specific URL.
  public static func loadString(from fileURL: URL, encoding: String.Encoding = .utf8) throws -> String {
    do {
      return try String(contentsOf: fileURL, encoding: encoding)
    } catch {
      throw ImportError.failedToRead(error.localizedDescription)
    }
  }

  /// Load a file from the main or provided bundle.
  public static func loadStringFromBundle(
    named fileName: String,
    withExtension fileExtension: String,
    bundle: Bundle = .main
  ) throws -> String {
    guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
      throw ImportError.resourceNotFound("\(fileName).\(fileExtension)")
    }
    return try loadString(from: url)
  }

  /// Load and decode JSON from a file URL.
  public static func loadJSON<T: Decodable>(
    from url: URL,
    type: T.Type,
    decoder: JSONDecoder = .init()
  ) throws -> T {
    let data = try Data(contentsOf: url)
    do {
      print("Attempting to decode JSON from URL \(url)")
      return try decoder.decode(type, from: data)
    } catch {
      print("Failed to decode JSON from URL \(url) with error \(error)")
      throw ImportError.decodingFailed(error)
    }
  }

  /// Load and decode JSON from bundle
  public static func loadJSON<T: Decodable>(
    named name: String,
    type: T.Type,
    withExtension ext: String = "json",
    bundle: Bundle = .main,
    decoder: JSONDecoder = .init()
  ) throws -> T {
    guard let url = bundle.url(forResource: name, withExtension: ext) else {
      print("Resource named \(name).\(ext) not found in bundle \(bundle)")
      throw ImportError.resourceNotFound("\(name).\(ext)")
    }
    return try loadJSON(
      from: url,
      type: type,
      decoder: decoder
    )
  }
  
//  public static func loadData(named fileName: String) throws -> Data {
//    let location: URL = .applicationSupportDirectory
//    
//  }
  

  //  /// Load raw string from a resource in a given bundle.
  //  public static func loadString(
  //    named fileName: String,
  //    withExtension fileExtension: String,
  //    from bundle: Bundle = .main
  //  ) throws -> String {
  //    guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
  //      throw ImportError.resourceNotFound("\(fileName).\(fileExtension)")
  //    }
  //    return try loadString(from: url)
  //  }
  //
  //  /// Load raw string from any file URL.
  //  public static func loadString(from fileURL: URL) throws -> String {
  //    do {
  //      return try String(contentsOf: fileURL)
  //    } catch {
  //      throw ImportError.failedToRead(error.localizedDescription)
  //    }
  //  }
  //
  //  /// Load and decode a JSON file into a given Decodable type.
  //  public static func loadJSON<T: Decodable>(
  //    named fileName: String,
  //    from bundle: Bundle = .main,
  //    fileExtension: String = "json",
  //    using decoder: JSONDecoder = .init()
  //  ) throws -> T {
  //    guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
  //      throw ImportError.resourceNotFound("\(fileName).\(fileExtension)")
  //    }
  //    let data = try Data(contentsOf: url)
  //    do {
  //      return try decoder.decode(T.self, from: data)
  //    } catch {
  //      throw ImportError.decodingFailed(error)
  //    }
  //  }
}
