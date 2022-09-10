//
//  Quote+Mock.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


extension Quote : MockProvider {

  static var mockHandler: (URLRequest) throws -> (HTTPURLResponse, Data)? = {
    guard $0.url?.path == "/api/quotes" else { return nil }
    return try Mock.successResponseData(fromJson: "Quotes")
  }
}

#endif
