//
//  Font+Styles.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


extension Font {

  private static var title3FontStyle: Font.TextStyle {
    var style = Font.TextStyle.title
    if #available(iOS 14, *) {
      style = .title3
    }
    return style
  }

  static var title3Font: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.title3,
              style: title3FontStyle)
  }
  static var title3EmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.title3Emphasis,
              style: title3FontStyle)
  }

  static var headlineFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.headline,
              style: .headline)
  }
  static var headlineEmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.headlineEmphasis,
              style: .headline)
  }

  static var bodyFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.body,
              style: .body)
  }
  static var bodyEmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.bodyEmphasis,
              style: .body)
  }

  static var calloutFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.callout,
              style: .callout)
  }
  static var calloutEmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.calloutEmphasis,
              style: .callout)
  }

  static var subheadlineFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.subheadline,
              style: .subheadline)
  }
  static var subheadlineEmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.subheadlineEmphasis,
              style: .subheadline)
  }

  static var footnoteFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.footnote,
              style: .footnote)
  }
  static var footnoteEmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.footnoteEmphasis,
              style: .footnote)
  }

  static var captionFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.caption,
              style: .caption)
  }
  static var captionEmphasisFont: Font {
    Font.font(spec: ReadyRemit.shared.appearance.fonts.captionEmphasis,
              style: .caption)
  }
}
