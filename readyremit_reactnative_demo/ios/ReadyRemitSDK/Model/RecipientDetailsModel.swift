//
//  RecipientDetailsModel.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 28/09/21.
//

import Foundation

struct RecipientDetailsModel {
    var recipientType = "Someone else"
    var firstName = ""
    var lastName = ""
    var nationality = ""
    var dateOfBirth = ""
    var dobMonth: String?
    var dobDay: String = ""
    var dobYear: String = ""
    var email = ""
    var amount = ""
    var phoneNumber = ""
    var country = "India"
    var city = ""
    var state: String?
    var pincode = ""
    var addressLine1 = ""
    var addressLine2 = ""
    var documentType: String?
    var documentNumber = ""
    
    func name() -> String {
        return "\(firstName) \(lastName)"
    }
}

struct RecipientBankDetails {
    var ifscCode: String = ""
    var bankName: String?
    var state: String?
    var city: String?
    var district: String?
    var accountNumber = ""
}
