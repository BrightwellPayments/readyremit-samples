//
//  RecipientDetailsService.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/5/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Combine


enum RecipientDetailsEndpoint {
  case createRecipient(params: [String: Any])
  case getRecipientFields(dstCountry: String, dstCurrency: String)
}

extension RecipientDetailsEndpoint : RequestBuilder {

  func request(withEnvironment environment: ApiEnvironmentProtocol, authTokenStore: AuthTokenStore) -> URLRequest {
    let components = URLComponents(string: "\(environment.baseUrl)\(path)")
    
    guard let url = components?.url else {
      preconditionFailure("Invalid URL.")
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    
    switch self {
    case .createRecipient(params: let params):
      request.httpBody = try! JSONSerialization.data(withJSONObject: params)
    case .getRecipientFields(dstCountry: let dstCountry, dstCurrency: let dstCurrency):
      print(":recipientFields: \(dstCountry) \(dstCurrency)")
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
    case .createRecipient: return "/recipients"
    case .getRecipientFields(dstCountry: let dstCountry, dstCurrency: let dstCurrency):
      return "/recipient-fields?dstCountryIso3Code=\(dstCountry)&dstCurrencyIso3Code=\(dstCurrency)&transferMethod=BANK_ACCOUNT&recipientType=PERSON"
    }
  }

  var httpMethod: String {
    switch self {
    case .createRecipient:
      return "POST"
    case .getRecipientFields:
      return "GET"
    }
  }
}


protocol RecipientDetailsService {

  var apiSession: ApiService { get }

  func postCreateRecipient(params: [String: Any]) -> AnyPublisher<CreateRecipient, ApiFailure>
  func fetchRecipientFields(
    dstCountry: String,
    dstCurrency: String)
}


extension RecipientDetailsService {

  typealias Endpoint = RecipientDetailsEndpoint

  func postCreateRecipient(params: [String: Any]) -> AnyPublisher<CreateRecipient, ApiFailure> {
    return apiSession.request(with: Endpoint.createRecipient(params: params))
  }
  
  func fetchRecipientFields(dstCountry: String, dstCurrency: String) -> AnyPublisher<GetRecipientFields, ApiFailure> {
    return apiSession.request(with: Endpoint.getRecipientFields(dstCountry: dstCountry, dstCurrency: dstCurrency))
  }
}
