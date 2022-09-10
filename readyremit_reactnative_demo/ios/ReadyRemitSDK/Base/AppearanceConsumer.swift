//
//  AppearanceConsumer.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


protocol AppearanceConsumer {
  static var appearance: ReadyRemitAppearance { get }
}


extension AppearanceConsumer {

  static var appearance: ReadyRemitAppearance {
    ReadyRemit.shared.appearance
  }
}
