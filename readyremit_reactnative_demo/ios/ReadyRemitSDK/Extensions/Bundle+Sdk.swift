//
//  Bundle+Sdk.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


extension Bundle {

  static var sdk: Bundle { Bundle(for: ReadyRemit.self) }

  var buildVersion: String {
    infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
  }
  var buildNumber: String {
    infoDictionary?["CFBundleVersion"] as? String ?? "0"
  }
  var buildType: BuildType {
    BuildType(rawOptional: infoDictionary?["BUILD_RELEASE_TYPE"] as? String)
  }

  var versionString: String {
    "\(buildVersion)\(buildType.buildSuffix)"
  }

  var info: String { "\(bundleIdentifier ?? "") : \(versionString)" }

}


extension Bundle {

  enum BuildType: String, CaseIterable, SafeInstantiable {
    static var fallback: Self = snapshot

    case snapshot = "SNAPSHOT"
    case alpha, beta, release

    var buildSuffix: String {
      switch self {
      case .release:
        return ""
      case .snapshot, .alpha, .beta:
        return "-\(self.rawValue).\(Bundle.sdk.buildNumber)"
      }
    }
  }
  
  func decodeJson<T: Decodable>(_ type: T.Type,
                            from file: String,
                            dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                            keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
      guard let url = self.url(forResource: file, withExtension: "json") else {
          fatalError("Failed to locate \(file) in bundle.")
      }

      guard let data = try? Data(contentsOf: url) else {
          fatalError("Failed to load \(file) from bundle.")
      }

      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = dateDecodingStrategy
      decoder.keyDecodingStrategy = keyDecodingStrategy

      do {
          return try decoder.decode(T.self, from: data)
      } catch DecodingError.keyNotFound(let key, let context) {
          fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
      } catch DecodingError.typeMismatch(_, let context) {
          fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
      } catch DecodingError.valueNotFound(let type, let context) {
          fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
      } catch DecodingError.dataCorrupted(_) {
          fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
      } catch {
          fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
      }
  }
}
