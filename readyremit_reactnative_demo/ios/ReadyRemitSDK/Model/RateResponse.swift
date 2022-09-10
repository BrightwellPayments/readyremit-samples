//
//  RateResponse.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 23/09/21.
//

import Foundation

struct RateResponse: Codable {
    var result: RateResult
}

struct RateResult: Codable {
    var quote: _Quote?
}

struct _Quote: Codable {
    var id: Int?
    var fxRate: String?
    var sendAmount: String?
    var _receiveAmount: String?
    lazy var receiveAmount: String? = {
        if let amount = _receiveAmount {
            return String(amount.dropLast(2))
        }
        return ""
    }()
    var transferFee: String?
    var totalCost: String?

    enum CodingKeys: String, CodingKey {
        case id, fxRate, sendAmount, transferFee, totalCost
        case _receiveAmount = "receiveAmount"
    }
}
