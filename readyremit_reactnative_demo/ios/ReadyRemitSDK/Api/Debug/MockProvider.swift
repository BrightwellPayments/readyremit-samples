//
//  MockProvider.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//

#if DEBUG

import Foundation


protocol MockProvider {
  static var mockHandler: (URLRequest) throws -> (HTTPURLResponse, Data)? { get }
}

#endif
