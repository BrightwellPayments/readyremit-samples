//
//  TextHelper.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 15/09/21.
//

import Foundation
import SwiftUI

extension Text {
    
    func hilightedText(str: String, searched: String) -> Text {
        
        guard !str.isEmpty && !searched.isEmpty else { return Text(str) }
        
        var result = Text("")
        var range = str.startIndex..<str.endIndex
        repeat {
            guard let found = str.range(of: searched, options: .caseInsensitive, range: range, locale: nil) else {
                result = result + Text(str[range])
                break
            }
            
            let prefix = str[range.lowerBound..<found.lowerBound]
            result = result + Text(prefix) + Text(str[found]).bold().foregroundColor(.red)
            
            range = found.upperBound..<str.endIndex
        } while (true)
        
        return result
    }
}
