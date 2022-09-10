//
//  AuthTokenStore.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


class AuthTokenStore {

  var authToken: OAuthToken

  internal init(authToken: OAuthToken) {
    self.authToken = authToken
  }
}
