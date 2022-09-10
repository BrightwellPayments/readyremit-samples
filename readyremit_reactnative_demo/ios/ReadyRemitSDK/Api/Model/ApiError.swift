//
//  ApiError.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


struct ApiError : Decodable {
  let message: String
  let description: String?
  let fieldId: String?
  let code: String
}

