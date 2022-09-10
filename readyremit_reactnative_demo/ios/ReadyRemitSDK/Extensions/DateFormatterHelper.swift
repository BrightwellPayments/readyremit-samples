//
//  DateFormatterHelper.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 30/09/21.
//

import Foundation

extension DateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter
    }
    
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var day: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
    static var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
}

extension Date {
    public static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!);
    }
}
