//
//  StringHelper.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/6/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


extension String {
  func capitalizedFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst().lowercased()
  }
}
