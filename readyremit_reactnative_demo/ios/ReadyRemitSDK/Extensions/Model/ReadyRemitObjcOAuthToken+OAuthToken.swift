//
//  ReadyRemitObjcOAuthToken+OAuthToken.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


internal extension ReadyRemitObjcOAuthToken {

  var oauthToken: OAuthToken {
    OAuthToken(tokenType: tokenType,
                          accessToken: accessToken,
                          expiresInSeconds: expiresInSeconds)
  }
}
