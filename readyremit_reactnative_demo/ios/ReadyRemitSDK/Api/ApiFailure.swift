//
//  ApiFailure.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


enum ApiFailure: Error {

  case network(cause: Error)
  case unexpected(cause: Error)
  case tokenExpired([ApiError])
  case tokenInvalid([ApiError])
  case failure([ApiError])
}
