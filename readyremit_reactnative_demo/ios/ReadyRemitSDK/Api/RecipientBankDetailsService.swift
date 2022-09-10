//
//  RecipientBankDetailsService.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/12/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Combine


enum RecipientBankDetailsEndpoint {
  case recipientAccount(params: [String: Any], id: String)
  case getRecipientAccountFields(dstCountry: String, dstCurrency: String)
}

extension RecipientBankDetailsEndpoint : RequestBuilder {
  func request(withEnvironment environment: ApiEnvironmentProtocol, authTokenStore: AuthTokenStore) -> URLRequest {
    let components = URLComponents(string: "\(environment.baseUrl)\(path)")
    
    guard let url = components?.url else {
      preconditionFailure("Invalid URL.")
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    switch self {
    case .recipientAccount(params: let params, id: _):
      request.httpBody = try! JSONSerialization.data(withJSONObject: params)
    case .getRecipientAccountFields(dstCountry: let dstCountry, dstCurrency: let dstCurrency):
      print(":recipientAccountFields: \(dstCountry) \(dstCurrency)")
      
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
    case .recipientAccount(params: _, id: let recipientId): return "/recipients/\(recipientId)/accounts"
    case.getRecipientAccountFields(dstCountry: let dstCountry, dstCurrency: let dstCurrency):
      return "/recipient-account-fields?dstCountryIso3Code=\(dstCountry)&dstCurrencyIso3Code=\(dstCurrency)&transferMethod=BANK_ACCOUNT&recipientType=PERSON"
    }
  }

  var httpMethod: String {
    switch self {
    case .recipientAccount:
      return "POST"
    case .getRecipientAccountFields:
      return "GET"
    }
  }
}


protocol RecipientBankDetailsService {

  var apiSession: ApiService { get }

  func postCreateRecipientAccount(params: [String: Any], id: String) -> AnyPublisher<RecipientAccount, ApiFailure>
}


extension RecipientBankDetailsService {

  typealias Endpoint = RecipientBankDetailsEndpoint

  func postCreateRecipientAccount(params: [String: Any], id: String) -> AnyPublisher<RecipientAccount, ApiFailure> {
    return apiSession.request(with: Endpoint.recipientAccount(params: params, id: id))
  }
  
  func fetchRecipientAccountFields(dstCountry: String, dstCurrency: String) -> AnyPublisher<GetRecipientFields, ApiFailure> {
    return apiSession.request(with: Endpoint.getRecipientAccountFields(dstCountry: dstCountry, dstCurrency: dstCurrency))
  }
}
