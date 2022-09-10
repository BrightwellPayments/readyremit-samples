//
//  OAuthToken.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


class OAuthToken: NSObject, Decodable {
  
  private(set) var tokenType: String?
  private(set) var accessToken: String
  private(set) var expiresInSeconds: Int?
  
  enum CodingKeys: String, CodingKey {
    case tokenType = "token_type"
    case accessToken = "access_token"
    case expiresInSeconds = "expires_in"
  }
  
  internal init(tokenType: String? = nil,
                accessToken: String,
                expiresInSeconds: Int? = nil) {
    self.tokenType = tokenType
    self.accessToken = accessToken
    self.expiresInSeconds = expiresInSeconds
  }
  
  let languageSelected: String = UserDefaults.standard.string(forKey: "languageSelected") ?? "en"
  
  var headers: [String: String]? {
    ["Authorization": "Bearer \(accessToken)", "ACCEPT-LANGUAGE": languageSelected]
  }
}
