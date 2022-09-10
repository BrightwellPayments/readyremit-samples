//
//  CountryCurrencies+Mock.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


extension CountryCurrencies {

  static var some: [CountryCurrencies] {
    let data = try! Bundle.dataFromJson("CountriesCurrencies")
    return try! JSONDecoder().decode([CountryCurrencies].self,
                                     from: data)
  }
}


extension CountryCurrencies : MockProvider {

  static var mockHandler: (URLRequest) throws -> (HTTPURLResponse, Data)?  = {
    guard $0.url?.path == "/api/options/countriescurrencies" else { return nil }
    return try Mock.successResponseData(fromJson: "CountriesCurrencies")
  }
}

#endif
