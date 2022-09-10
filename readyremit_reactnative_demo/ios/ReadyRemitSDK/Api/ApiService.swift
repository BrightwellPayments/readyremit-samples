//
//  ApiService.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Combine
import SwiftUI


protocol RequestBuilder {

  func request(withEnvironment environment: ApiEnvironmentProtocol,
               authTokenStore: AuthTokenStore) -> URLRequest
}


protocol ApiService {

  func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, ApiFailure>
}


struct ApiSession : ApiService {

  private enum InternalError: Error {
    case statusCodeError(code: Int, errors: [ApiError])
  }

  private let environment: ApiEnvironmentProtocol
  private let authTokenStore: AuthTokenStore
  private let decoder = JSONDecoder()

  init(environment: ApiEnvironmentProtocol,
       authTokenStore: AuthTokenStore) {
    self.environment = environment
    self.authTokenStore = authTokenStore
  }

  /*
    From Pat:
    I looked through this quickly and I am thinking it might be better to use callbacks and pass in the value instead of returning value.
    If you look in the WebService.swift we used a completion callback and we passed in the results.
  */
  func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, ApiFailure> where T : Decodable {
    environment.session
      .dataTaskPublisher(for: builder.request(withEnvironment: environment,
                                              authTokenStore: authTokenStore))
      .mapError { ApiFailure.network(cause: $0) }
      .tryMap { data, response in
        switch response.status {
        case 200...299:
          // TODO: This is messy but it's the only way I could figure out how to print parsing errors for easier debugging
          do {
            let result = try self.decoder.decode(T.self, from: data)
            return result
          }
          catch let DecodingError.typeMismatch(type, context)  {
             #if DEBUG
               print("Type '\(type)' mismatch:", context.debugDescription)
               print("codingPath:", context.codingPath)
             #endif
            // TODO: Repeated code, find a way to refactor
            return try self.decoder.decode(T.self, from: data)
          }
          catch {
            #if DEBUG
              print("Error info: \(error)")
            #endif
            // TODO: Repeated code, find a way to refactor
            return try self.decoder.decode(T.self, from: data)
          }
        default:
          let apiErrors = try self.decoder.decode([ApiError].self, from: data)
          throw InternalError.statusCodeError(code: response.status, errors: apiErrors)
        }
      }
      .mapError {
        if let failure = $0 as? ApiFailure {
          return failure
        }
        switch $0 {
        case InternalError.statusCodeError(code: let code, errors: let errors):
          switch code {
          case 401: return ApiFailure.tokenExpired(errors)
          case 403: return ApiFailure.tokenInvalid(errors)
          default: return ApiFailure.failure(errors)
          }
        default:
          return ApiFailure.unexpected(cause: $0)
        }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
