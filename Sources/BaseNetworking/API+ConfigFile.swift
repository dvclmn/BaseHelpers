//
//  API+Helpers.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation

extension Bundle {

  /// This requires the following set-up:
  /// 
  /// 1. Add `Config.xcconfig` file to project
  /// 2. Add sensitive data e.g. `STEAM_SECRET = 4620doa8408...`
  ///   IMPORTANT: For this to work, do *not* surround the value in `"`
  ///   Just leave it bare, as it is above
  /// 
  /// 3. Ensure this config file is not added to source control (ignored)
  /// 4. Add the config file to the project (not target) via
  ///   `Project Settings > Info > Configurations`,
  ///   in the Debug dropdown. Just to the project, not the target(s).
  /// 5. Finally, add each reference to sensitive data to the `Info.plist`, like so:
  /// ```
  /// <key>SteamSecret</key>
  /// <string>$(STEAM_SECRET)</string>
  /// ```
  /// 6. The above `key` is what you provide to the below `key` parameter
  ///
  /// - Parameter key: Should match exactly with the key in `Info.plist`
  /// - Returns: Value from the corresponding `Info.plist` entry
  public static func getStringFromInfoDict(_ key: String, bundle: Bundle = .main) throws -> String {
    guard let result = bundle.object(forInfoDictionaryKey: key) as? String else {
      throw ConfigError.missingKey(key)
    }
    guard !result.isEmpty else {
      throw ConfigError.invalidValue(key)
    }
    return result
  }
}

enum ConfigError: Error {
  case missingKey(String)
  case invalidValue(String)
}
