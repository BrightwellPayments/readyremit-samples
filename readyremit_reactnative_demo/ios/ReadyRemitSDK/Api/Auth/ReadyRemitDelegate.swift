//
//  ReadyRemitDelegate.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//

import Foundation


@objc
public protocol ReadyRemitDelegate {

  func onAuthTokenRequest(success: @escaping (String) -> Void, failure: @escaping () -> Void )
  func onSubmitTransfer(transferRequest: ReadyRemit.TransferRequest,
                        success: @escaping (String) -> Void,
                        failure: @escaping (String) -> Void)
}
