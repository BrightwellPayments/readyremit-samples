//
//  Bundle+JsonData.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

import Foundation

#if DEBUG


extension Bundle {

  static func dataFromJson(_ name: String) throws -> Data {
    let bundle = Bundle(for: MockUrlProtocol.self)
    guard let url = bundle.url(forResource: name, withExtension: "json") else {
      throw Mock.MockError.notFound
    }
    return try Data(contentsOf: url)
  }
}

#endif
