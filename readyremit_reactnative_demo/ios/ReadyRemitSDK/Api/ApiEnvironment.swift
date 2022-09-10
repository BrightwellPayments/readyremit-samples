//
//  ApiEnvironment.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


protocol ApiEnvironmentProtocol {
  var session: URLSession { get }
  var baseUrl: String { get }
  var headers: [String: String]? { get }
}


enum ApiEnvironment : Int, RawRepresentable, ApiEnvironmentProtocol {
  case production
  case sandbox
  #if DEBUG
  case development
  case postman
  case mock
  #endif
}


extension ApiEnvironment {

  var session: URLSession {
    switch self {
    case .production, .sandbox:
      return URLSession.shared
    #if DEBUG
    case .development:
      return URLSession(configuration: URLSessionConfiguration.ephemeral)
    case .postman:
      let config = URLSessionConfiguration.ephemeral
      config.protocolClasses = [PostmanUrlProtocol.self]
      return URLSession(configuration: config)
    case .mock:
      let config = URLSessionConfiguration.ephemeral
      config.protocolClasses = [MockUrlProtocol.self]
      MockUrlProtocol.setup()
      return URLSession(configuration: config)
    #endif
    }
  }

  var baseUrl: String {
    switch self {
    case .production, .sandbox:
      return "https://sandbox-api.readyremit.com/v1"
    #if DEBUG
    case .postman:
      return "https://98664d42-88ba-4b8f-9896-fa105537191b.mock.pstmn.io"
    case .development:
      return "https://dev-api.readyremit.com/v1"
    case .mock:
      return "https://mock.rr.brightwell.com"
    #endif
    }
  }

  var headers: [String: String]? {
    switch self {
    case .production, .sandbox: return nil
    #if DEBUG
    case .development: return nil
    case .postman:
      return ["x-api-key": "PMAK-6165becc5a96f80046c6a18c-48385e850ad1a9165f7f3315bd85d64308"]
    case .mock: return nil
    #endif
    }
  }
}
