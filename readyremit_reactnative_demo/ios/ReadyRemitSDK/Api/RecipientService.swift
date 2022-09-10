//
//  RecipientService.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 31/05/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation
import Combine

enum RecipientEndpoint {
  case getRecipients
  case getSenders
}

extension RecipientEndpoint : RequestBuilder {

  func request(withEnvironment environment: ApiEnvironmentProtocol, authTokenStore: AuthTokenStore) -> URLRequest {
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
    case .getRecipients: return "/recipients-with-accounts?senderId=e087b0da-6238-46e7-b749-43331451c3f6"
    case .getSenders: return "/senders/e087b0da-6238-46e7-b749-43331451c3f6"
    }
  }

  var httpMethod: String {
    switch self {
    case .getRecipients:
      return "GET"
    case .getSenders:
      return "GET"
    }
  }
}


protocol RecipientService {

  var apiSession: ApiService { get }

  func getRequestRecipient() -> AnyPublisher<RecipientResponse, ApiFailure>
  func getSendersData() -> AnyPublisher<SenderResponse, ApiFailure>
}


extension RecipientService {

  typealias Endpoint = RecipientEndpoint

  func getRequestRecipient() -> AnyPublisher<RecipientResponse, ApiFailure> {
    return apiSession.request(with: Endpoint.getRecipients)
  }
  
  func getSendersData() -> AnyPublisher<SenderResponse, ApiFailure> {
    return apiSession.request(with: Endpoint.getSenders)
  }
}
