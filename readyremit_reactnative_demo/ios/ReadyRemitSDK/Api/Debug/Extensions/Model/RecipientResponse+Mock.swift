//
//  RecipientResponse+Mock.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


extension RecipientResponse : MockProvider {

  static var mockHandler: (URLRequest) throws -> (HTTPURLResponse, Data)? = { request in
    guard request.url?.path == "/api/receiver" else { return nil }
    return try Mock.successResponseData(fromJson: "RecipientResponse")
  }
}

#endif

