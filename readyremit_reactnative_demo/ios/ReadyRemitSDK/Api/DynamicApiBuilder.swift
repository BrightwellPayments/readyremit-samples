//
//  RecipientBankDetailsService.swift
//  ReadyRemitSDK
//
//  Created by Sergio García on 8/3/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Combine


enum DynamicApiEndpoint {
  case requestDynamicApi(url: String)
}

extension DynamicApiEndpoint : RequestBuilder {
  func request(withEnvironment environment: ApiEnvironmentProtocol, authTokenStore: AuthTokenStore) -> URLRequest {
    let components = URLComponents(string: "\(path)")
    
    guard let url = components?.url else {
      preconditionFailure("Invalid URL.")
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    switch self {
    case .requestDynamicApi(url: let url):
      print(":dstCountry: \(url)")
      
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
    case .requestDynamicApi(url: let url):
      return url
    }
  }

  var httpMethod: String {
    switch self {
    case .requestDynamicApi:
      return "GET"
    }
  }
}


protocol DynamicApiService {

  var apiSession: ApiService { get }

  func postCreateRecipientAccount(params: [String: Any], id: String) -> AnyPublisher<RecipientAccount, ApiFailure>
}


extension DynamicApiService {

  typealias Endpoint = DynamicApiEndpoint
  
  func fetchDynamicApi(url: String) -> AnyPublisher<[OptionsSet], ApiFailure> {
    return apiSession.request(with: Endpoint.requestDynamicApi(url: url))
  }
}

