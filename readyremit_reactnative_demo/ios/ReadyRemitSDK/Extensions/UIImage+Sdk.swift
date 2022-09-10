//
//  UIImage+Sdk.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit


extension UIImage {

  convenience init?(namedSdk: String) {
    self.init(named: namedSdk, in: Bundle.sdk, with: nil)
  }
  
  var base64: String? {
    self.jpegData(compressionQuality: 0.3)?.base64EncodedString()
  }
}
