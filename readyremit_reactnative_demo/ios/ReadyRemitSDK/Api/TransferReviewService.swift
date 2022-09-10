//
//  TransferReviewService.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/20/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Combine


enum TransferReviewEndpoint {
  case transfer(id: String)
}


extension TransferReviewEndpoint : RequestBuilder {

  func request(withEnvironment environment: ApiEnvironmentProtocol,
               authTokenStore: AuthTokenStore) -> URLRequest {
    let components = URLComponents(string: "\(environment.baseUrl)\(path)")
    
    guard let url = components?.url else {
      preconditionFailure("Invalid URL.")
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    var headers = authTokenStore.authToken.headers ?? [:]
    if let environmentHeaders = environment.headers {
      headers.merge(environmentHeaders) { old, _ in old }
    }
    headers.forEach {
      request.addValue($0.1, forHTTPHeaderField: $0.0)
    }
    return request
  }

  var path: String {
    switch self {
    case .transfer(let id): return "/transfers/\(id)"
    }
  }

  var httpMethod: String {
    switch self {
    case .transfer:
      return "GET"
    }
  }
}


protocol TransferReviewService {

  var apiSession: ApiService { get }

  func getTransfer(id: String) -> AnyPublisher<Transfer, ApiFailure>
}


extension TransferReviewService {

  typealias Endpoint = TransferReviewEndpoint
  
  func getTransfer(id: String) -> AnyPublisher<Transfer, ApiFailure> {
    return apiSession.request(with: Endpoint.transfer(id: id))
  }
}
