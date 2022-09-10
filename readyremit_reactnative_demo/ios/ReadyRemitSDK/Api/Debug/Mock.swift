//
//  Mock.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


struct Mock {

  enum MockError: Error {
    case notFound
  }

  static func successResponseData(fromJson: String) throws -> (HTTPURLResponse, Data) {
    (HTTPURLResponse(), try Bundle.dataFromJson(fromJson))
  }
}

#endif
