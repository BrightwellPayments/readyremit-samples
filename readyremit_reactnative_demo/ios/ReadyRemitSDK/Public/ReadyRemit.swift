//
//  ReadyRemit.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI


@objc
public enum ReadyRemitApiEnvironment : Int {

  case production, sandbox
  #if DEBUG
  case development, postman, mock
  #endif

  internal var environment: ApiEnvironment {
    switch self {
    case .production: return .production
    case .sandbox: return .sandbox
    #if DEBUG
    case .development: return .development
    case .postman: return .postman
    case .mock: return .mock
    #endif
    }
  }
}


@objc
public class ReadyRemit : NSObject {

  @objc
  public static let shared = ReadyRemit()

  @objc public var environment: ReadyRemitApiEnvironment {
    get {
      return ReadyRemitApiEnvironment(rawValue: apiEnvironment.rawValue) ?? .production
    }
    set {
      apiEnvironment = newValue.environment
    }
  }

  @objc public var appearance = ReadyRemitAppearance()
  public var closeSDKButtonText: String?
  private var delegate: ReadyRemitDelegate?

  internal var apiEnvironment: ApiEnvironment = {
    #if DEBUG
    .development
    #else
    .production
    #endif
  }()
  private var authTokenStore: AuthTokenStore!
  private weak var navigation: UINavigationController?

  @objc
  public var info: String { Bundle.sdk.info }

  //MARK: - SDK-Entry: Swift-UIKit (Designated)

  public func launch(inNavigation: UINavigationController,
                     delegate: ReadyRemitDelegate,
                     onLaunch: (() -> Void)?) {
    navigation = inNavigation
    self.delegate = delegate
    delegate.onAuthTokenRequest { [weak self] authToken in
      DispatchQueue.main.async {
        guard let hostVC = self?.launchEntryUIKit(authToken: authToken, onLaunch: onLaunch) else {
          preconditionFailure("Failed to initiliaze Ready Remit Hosting Controller.")
        }
        self?.navigation?.pushViewController(hostVC, animated: true)
      }
    } failure: {
      return
    }
  }

  //MARK: SDK-Entry: SwiftUI

  public func launchEntrySwiftUi(authToken: String,
                                 onLaunch: (() -> Void)?) -> AnyView {
    self.authTokenStore = AuthTokenStore(authToken: OAuthToken(accessToken: authToken))
    let api = ApiSession(environment: apiEnvironment, authTokenStore: authTokenStore)
    let model = RecipientsViewModel(apiSession: api)
    return AnyView(RecipientsListView(model: model,
                                      onLaunch: onLaunch,
                                      onDismiss: {}))
  }
  
  @objc public func languageSelected(_ lang: String) {
    var selected: String = ""
    switch lang {
    case "en_us":
      selected = "en"
    case "es_mx":
      selected = "es"
    case "de_de":
      selected = "de"
    default:
      selected = "en"
    }
    UserDefaults.standard.set(selected, forKey: "languageSelected")
  }
  
  public func switchFeatureFlags(_ flag: String, _ status: Bool = false) {
    UserDefaults.standard.set(status, forKey: flag)
  }

  //MARK: SDK-Entry: ObjC

  @objc
  public func launchObjc(inNavigation: UINavigationController,
                         delegate: ReadyRemitDelegate,
                         onLaunch: (() -> Void)?) {
    launch(inNavigation: inNavigation, delegate: delegate, onLaunch: onLaunch)
  }

  internal func launchEntryUIKit(authToken: String,
                                 onLaunch: (() -> Void)?) -> UIViewController {
    UIHostingController(rootView: launchEntrySwiftUi(authToken: authToken,
                                                     onLaunch: onLaunch))
  }
  
  //MARK: Create Transfer
  
  internal func submitTransfer(transferRequest: ReadyRemit.TransferRequest, completionHandler: @escaping (Result<String, ApiFailure>) -> Void) {
    guard let delegate = delegate else {
      preconditionFailure("ReadyRemit delegate handler not found")
    }
    delegate.onSubmitTransfer(transferRequest: transferRequest) { transferId in
      completionHandler(.success(transferId))
    } failure: { errorDescription in
      completionHandler(.failure(.failure([ApiError(message: errorDescription,
                                                    description: nil,
                                                    fieldId: nil,
                                                    code: "")])))
    }
  }
}
