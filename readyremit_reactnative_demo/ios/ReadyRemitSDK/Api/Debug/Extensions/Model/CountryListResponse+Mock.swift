//
//  CountryListResponse+Mock.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


extension CountryListResponse : MockProvider {

  static var mockHandler: (URLRequest) throws -> (HTTPURLResponse, Data)? = { request in
    guard request.url?.path == "/api/transfer" else { return nil }
    return try Mock.successResponseData(fromJson: "CountryListResponse")
  }
}

#endif
