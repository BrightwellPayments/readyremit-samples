//
//  ApiFailure+Identifiable.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


extension ApiFailure : Identifiable {

  var id: String { "\(self)" }
}
