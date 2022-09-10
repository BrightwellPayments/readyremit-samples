//
//  AttributedTextView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/17/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI
import UIKit


enum AttributedTextType {
  case text(String)
  case link(text: String, url: String)
}

struct AttributedTextView: View {
  
  let contents: [AttributedTextType]
  let foregroundColor: UIColor
  let backgroundColor: UIColor
  let font: UIFont
  
  var body: some View {
    let attributedText = NSMutableAttributedString()
    
    for content in contents {
      switch content {
      case .text(let section):
        let text = NSMutableAttributedString(string: section)
        let standartTextAttributes: [NSAttributedString.Key : Any] = [
          NSAttributedString.Key.font: font,
          NSAttributedString.Key.foregroundColor: foregroundColor
        ]
        text.addAttributes(standartTextAttributes, range: text.range)
        attributedText.append(NSAttributedString(string: section))
      case .link(let section, let url):
        let textWithHyperlink = NSMutableAttributedString(string: section)
        let hyperlinkTextAttributes: [NSAttributedString.Key : Any] = [
          NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
          NSAttributedString.Key.link : url
          
        ]
        textWithHyperlink.addAttributes(hyperlinkTextAttributes, range: textWithHyperlink.range)
        attributedText.append(textWithHyperlink)
      }
    }
    
    return Text(attributedText)
  }
}
