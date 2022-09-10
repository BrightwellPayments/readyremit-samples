//
//  TransferDetailsService.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Combine


enum TransferDetailsEndpoint {

  case transferCountries
  case corridor(dstCountryIso3Code: String)
  case transferQuote(params: [URLQueryItem])
  case getRecipientData(recipientId: String)
}


extension TransferDetailsEndpoint : RequestBuilder {

  func request(withEnvironment environment: ApiEnvironmentProtocol,
               authTokenStore: AuthTokenStore) -> URLRequest {
    var components = URLComponents(string: "\(environment.baseUrl)\(path)")
    
    switch self {
    case .transferCountries, .corridor, .getRecipientData:
      break
    case .transferQuote(params: let params):
      components?.queryItems = params
    }
    
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
    case .transferCountries: return "/countries"
    case .corridor(dstCountryIso3Code: let dstCountry):
      return "/corridors?dstCountryIso3Code=\(dstCountry)&transferMethod=BANK_ACCOUNT"
    case .transferQuote: return "/quote"
    case .getRecipientData(recipientId: let recipientId):
      return "/recipients/\(recipientId)"
    }
  }

  var httpMethod: String {
    switch self {
    case .transferCountries, .transferQuote, .corridor, .getRecipientData:
      return "GET"
    }
  }
}


protocol TransferDetailsService {

  var apiSession: ApiService { get }

  func getCountries() -> AnyPublisher<[Country], ApiFailure>
  func getCorridor(dstCountryIsoCode: String) -> AnyPublisher<[Corridor], ApiFailure>
  func getQuote(params: [String: String]) -> AnyPublisher<Quote, ApiFailure>
  func getRecipient(recipientId: String) -> AnyPublisher<CreateRecipient, ApiFailure>
}


extension TransferDetailsService {

  typealias Endpoint = TransferDetailsEndpoint

  func getCountries() -> AnyPublisher<[Country], ApiFailure> {
    apiSession.request(with: Endpoint.transferCountries)
  }
  
  func getRecipient(recipientId: String) -> AnyPublisher<CreateRecipient, ApiFailure> {
    apiSession.request(with: Endpoint.getRecipientData(recipientId: recipientId))
  }
  
  func getCorridor(dstCountryIsoCode: String) -> AnyPublisher<[Corridor], ApiFailure> {
    apiSession.request(with: Endpoint.corridor(dstCountryIso3Code: dstCountryIsoCode))
  }
  
  func getQuote(params: [String: String]) -> AnyPublisher<Quote, ApiFailure> {
    var queryItems = [URLQueryItem]()
    for param in params {
      queryItems.append(URLQueryItem(name: param.key, value: param.value))
    }
    return apiSession.request(with: Endpoint.transferQuote(params: queryItems))
  }
}
