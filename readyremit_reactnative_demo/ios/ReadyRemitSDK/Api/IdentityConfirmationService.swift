//
//  IdentityConfirmationService.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 30/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Combine

enum IdentityConfirmationEndpoint {
  case identityConfirmation(params: [String: String], senderId: String)
}

extension IdentityConfirmationEndpoint: RequestBuilder {
  func request(withEnvironment environment: ApiEnvironmentProtocol, authTokenStore: AuthTokenStore) -> URLRequest {
    let components = URLComponents(string: "\(environment.baseUrl)\(path)")
    guard let url = components?.url else {
      preconditionFailure("Invalid URL.")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    switch self {
    case .identityConfirmation(params: let params, senderId: _):
      request.httpBody = try! JSONSerialization.data(withJSONObject: params)
    }
    
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
    case .identityConfirmation(_, let senderId):
      return "/senders/\(senderId)/idverification"
    }
  }

  var httpMethod: String {
    switch self {
      case .identityConfirmation(_, _):
      return "POST"
    }
  }
}

protocol IdentityConfirmationService {

  var apiSession: ApiService { get }
  
  func sendValidationData(params: [String: String], senderId: String) -> AnyPublisher<[String], ApiFailure>
}


extension IdentityConfirmationService {

  typealias Endpoint = IdentityConfirmationEndpoint
  func sendValidationData(params: [String: String], senderId: String) -> AnyPublisher<[String], ApiFailure> {
    return apiSession.request(with: Endpoint.identityConfirmation(params: params, senderId: senderId))
  }
}
