//
//  PostmanUrlProtocol.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


public struct MockErrorProvider {
  public static var errorEveryNumberOfRequests = 0
  static var requestCounter = 0
  private static var errorMap = ["401", "403", "500", "400", "404"]
  static var error: String? {
    defer { requestCounter += 1 }
    guard errorEveryNumberOfRequests > 0 else { return nil }
    let mod = requestCounter % errorEveryNumberOfRequests
    guard mod == 0 else { return nil }
    let index = Int(requestCounter/errorEveryNumberOfRequests) % errorMap.count
    print("Requesting error: \(errorMap[index])")
    return errorMap[index]
  }
}


class PostmanUrlProtocol : URLProtocol {

  static var requestHandlers: [((URLRequest) throws -> (HTTPURLResponse, Data)?)] = []
  static let delay: TimeInterval? = nil
  static let queue = DispatchQueue(label: "Mock-Network")

  let defaultSession = URLSession(configuration: .ephemeral)
  var connection: NSURLConnection!

  override class func canInit(with request: URLRequest) -> Bool {
    true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    guard let url = request.url else  { return request }
    guard let error = MockErrorProvider.error else { return request }
    var components = URLComponents(url: url, resolvingAgainstBaseURL:true)
    var queryItems = components?.queryItems ?? []
    queryItems.append(URLQueryItem(name: "statusCode", value: error))
    components?.queryItems = queryItems
    var mutableRequest = request
    mutableRequest.url = components?.url
    return mutableRequest
  }

  enum PostmanError : Error {
    case noResponseNoData
  }

  override func startLoading() {

    let task = self.defaultSession.dataTask(with: self.request) { data, response, error in
      if let error = error {
        self.client?.urlProtocol(self, didFailWithError: error)
        return
      }
      guard let response = response, let data = data else {
        self.client?.urlProtocol(self, didFailWithError: PostmanError.noResponseNoData)
        return
      }
      self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      self.client?.urlProtocol(self, didLoad: data)
      self.client?.urlProtocolDidFinishLoading(self)
    }
    task.resume()
  }

  override func stopLoading() {}
}

#endif
