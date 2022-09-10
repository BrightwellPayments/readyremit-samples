//
//  SafeInstantiable.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


protocol SafeInstantiable: RawRepresentable {
  static var fallback: Self { get }
}


extension SafeInstantiable {

  init(rawOptional: RawValue?) {
    var _self: Self?
    if let raw = rawOptional {
      _self = Self(rawValue: raw)
    }
    self = _self ?? .fallback
  }
}
