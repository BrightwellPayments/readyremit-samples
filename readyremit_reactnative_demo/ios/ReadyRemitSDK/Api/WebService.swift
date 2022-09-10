//
//  WebService.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


enum ErrorState: Error, LocalizedError {

  case domainError,
       decodingError,
       serverNotResponding,
       authenticationFailed,
       error(string: String)

  var errorDescription: String? {
    switch self {
    case .domainError:
      return "The Internet connection appears to be offline"
    case .decodingError:
      return "Something went wrong"
    case .serverNotResponding:
      return "Server not responding"
    case .authenticationFailed:
      return "Token Expired"
    case .error(string: let string):
      return string
    }
  }
}

struct Resource<T: Codable> {
  var path: String
  var httpMethod: HttpMethod = .get
  var parameters: Json? = nil
}

struct WebService {

  let session: URLSession
  let environment: ApiEnvironment

  init() {
    self.init(environment: ReadyRemit.shared.apiEnvironment)
  }

  init(environment: ApiEnvironment) {
    self.environment = environment
    session = environment.session
  }

  func send<T>(resource: Resource<T>,
               completion: @escaping (Result<T, ErrorState>) -> Void) {
    fetchLiveData(resource: resource, completion: completion)
  }

  private func fetchLiveData<T>(resource: Resource<T>,
                                completion: @escaping (Result<T, ErrorState>) -> Void) {
    guard let request = request(resource: resource) else { return }
    print("\(request.url?.absoluteString ?? "no url")")
    session.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        DispatchQueue.main.async {
          completion(.failure(.domainError))
        }
        return
      }
      guard let statusCode = response?.status,
            (200...299).contains(statusCode) || statusCode == 422 else {
              switch response?.status {
              case 401, 403:
                DispatchQueue.main.async {
                  completion(.failure(.authenticationFailed))
                }
                return
              default:
                break
              }
              DispatchQueue.main.async {
                completion(.failure(.decodingError))
              }
              return
            }
      if let str = String(data: data, encoding: .utf8) {
        print(str)
      }
      let result = try? JSONDecoder().decode(T.self, from: data)
      if let result = result {
        DispatchQueue.main.async {
          completion(.success(result))
        }
      } else {
        DispatchQueue.main.async {
          completion(.failure(.decodingError))
        }
      }
    }.resume()
  }

  private func request<T>(resource: Resource<T>) -> URLRequest? {
    guard let url = URL(string: "\(environment.baseUrl)/\(resource.path)") else { return nil }
    let credentials = "PEF1dGhlbnRpY2F0aW9uPjxJZD4zMmQ3NzkzMy03MzJkLTQ5YjYtYTllYi1mZDZlZWNhN2Q3ZjE8L0lkPjxVc2VyTmFtZT51eWxxNmhOTks1ZXRqRk5naExPZzhlcUt0TklwZThRRXF5QnlZSmtwbDBydGkzKzhMWlhRM2ZlWk81RjRScDNtR2J1THhzSHhacUFLeHM1TGFLVjhLT0dibnVKUHNRQVFwM1I1V3pPU0tFdWcvRmNFbDVYelVnMzBZaENUZVRmcFNSbllaSnpUTi8wNml5bElOVCsrbGErRmVtWHFEMXhZQ21sWElSSmlpMHc9PC9Vc2VyTmFtZT48UGFzc3dvcmQ+VVgvajZHTEVvVzNxN214UWJzWnQyZ2h1eEVvaG84N3RjdVZuT1NwdTE0M0VDWjJSSDZIcmJ1WTlFekdMS01TWlBsVUwxSCtLSWd5eksrMXNMYllFVnBWdHBPSXk0VkozcFFvcFM5a0IwVFdzdno5SC9MTzJJdWFtMzlJamFjaHpPUWRzQnpjc05NU2RoTDBCY3lXQlZ6UWkvV2xXNGtXcHJkQ29WV1hwZDhRPTwvUGFzc3dvcmQ+PEJyYW5jaElkPlFJUjRmOVFzS29rYzdoWVBqU0V5UmNINVYrbnJOM3JnVWdkdUZlbkk2bEg4ZXNQQzR1TjF3eklTWGZTdE1EU1pkU0o3ekxqV3B5NGZwd0JQd0FUU1ErdXlwTzd3NWE3RUJZR3E3WVdHV3QvckUrVkZMdkN2VkU2aUI4RUNhUWV0VXBXVk9IbUJyRlZpd3dBTDMvS1VhOEJiNmtoWk8zWEpBVUZjVjBicDlXST08L0JyYW5jaElkPjwvQXV0aGVudGljYXRpb24+"
    var request = URLRequest(url: url)
    request.httpMethod = resource.httpMethod.rawValue
    request.allHTTPHeaderFields = ["Content-Type": "application/json",
                                   "Accept": "application/json",
                                   "Credentials": credentials]
    if let params = resource.parameters,
        let body = try? JSONSerialization.data(withJSONObject: params, options: []) {
      request.httpBody = body
    }
    return request
  }
}
