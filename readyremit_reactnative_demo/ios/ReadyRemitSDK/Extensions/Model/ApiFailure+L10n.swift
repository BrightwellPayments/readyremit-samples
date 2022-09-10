//
//  ApiFailure+L10n.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


extension ApiFailure {

  var title: String {
    switch self {
    case .network: return L10n.rrmErrorNetworkTitle
    case .unexpected,
        .tokenExpired,
        .tokenInvalid:
      return L10n.rrmErrorUnexpectedTitle
    case .failure(let errors):
      return errors.first?.message ?? L10n.rrmErrorApiTitle
    }
  }

  var message: String {
    switch self {
    case .network: return L10n.rrmErrorNetworkMessage
    case .unexpected,
        .tokenExpired,
        .tokenInvalid:
      return L10n.rrmErrorUnexpectedMessage
    case .failure(let errors):
      return errors.first?.message ?? L10n.rrmErrorApiMessage
    }
  }
}
