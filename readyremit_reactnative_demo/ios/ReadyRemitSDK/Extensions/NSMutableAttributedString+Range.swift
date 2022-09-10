//
//  NSMutableAttributedString+Range.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/17/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation


extension NSMutableAttributedString {
  
  var range: NSRange {
    NSRange(location: 0, length: self.length)
  }
}
