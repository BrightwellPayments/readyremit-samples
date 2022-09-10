//
//  ReadyRemitFonts.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import UIKit


@objc public class ReadyRemitFonts : NSObject {

  typealias FontSpec = ReadyRemit.FontSpec

  public var title3: ReadyRemit.FontSpec?//iOS 14 +
  public var title3Emphasis: ReadyRemit.FontSpec? = FontSpec(weight: .semibold)//iOS 14 +
  public var headline: ReadyRemit.FontSpec?
  public var headlineEmphasis: ReadyRemit.FontSpec? = FontSpec(italic: true)
  public var body: ReadyRemit.FontSpec?
  public var bodyEmphasis: ReadyRemit.FontSpec? = FontSpec(weight: .semibold)
  public var callout: ReadyRemit.FontSpec?
  public var calloutEmphasis: ReadyRemit.FontSpec? = FontSpec(weight: .semibold)
  public var subheadline: ReadyRemit.FontSpec?
  public var subheadlineEmphasis: ReadyRemit.FontSpec? = FontSpec(weight: .semibold)
  public var footnote: ReadyRemit.FontSpec?
  public var footnoteEmphasis: ReadyRemit.FontSpec? = FontSpec(weight: .semibold)
  public var caption: ReadyRemit.FontSpec?
  public var captionEmphasis: ReadyRemit.FontSpec? = FontSpec(weight: .medium)
}
