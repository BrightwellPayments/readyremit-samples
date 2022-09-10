//
//  ReadyRemitObjcOAuthToken.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


@objc
public class ReadyRemitObjcOAuthToken : NSObject, Decodable {

  let tokenType: String
  let accessToken: String
  let expiresInSeconds: Int

  enum CodingKeys: String, CodingKey {
    case tokenType = "token_type"
    case accessToken = "access_token"
    case expiresInSeconds = "expires_in"
  }
  
  @objc
  public init(tokenType: String,
              accessToken: String,
              expiresInSeconds: Int) {
    self.tokenType = tokenType
    self.accessToken = accessToken
    self.expiresInSeconds = expiresInSeconds
    super.init()
  }
}
