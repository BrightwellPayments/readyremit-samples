//
//  MockUrlProtocol.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


class MockUrlProtocol : URLProtocol {

  static var requestHandlers: [((URLRequest) throws -> (HTTPURLResponse, Data)?)] = []
  static let delay: TimeInterval? = nil
  static let queue = DispatchQueue(label: "Mock-Network")

  override class func canInit(with request: URLRequest) -> Bool {
    true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  override func startLoading() {
    if let delay = Self.delay {
      Self.queue.asyncAfter(deadline: .now() + delay) {
        self.doStartLoading()
      }
    } else {
      doStartLoading()
    }
  }

  private func doStartLoading() {
    do {
      var responseData: (HTTPURLResponse, Data)?
      for handler in Self.requestHandlers {
        if let (response, data) = try handler(request) {
          responseData = (response, data)
          break
        }
      }
      guard let response = responseData?.0, let data = responseData?.1  else {
        throw Mock.MockError.notFound
      }
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }

  override func stopLoading() {}
}


extension MockUrlProtocol {

  class func setup() {
    MockUrlProtocol.requestHandlers.append(contentsOf: [
      CountryCurrencies.mockHandler,
      CountryListResponse.mockHandler,
      Quote.mockHandler,
      RecipientResponse.mockHandler,
      User.mockHandler,
    ])
  }
}

#endif
