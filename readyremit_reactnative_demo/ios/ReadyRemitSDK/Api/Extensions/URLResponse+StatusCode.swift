//
//  URLResponse+StatusCode.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation


extension URLResponse {

  var status: Int {
    (self as! HTTPURLResponse).statusCode
  }
}
