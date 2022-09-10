//
//  TextViewModifier.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import Foundation
import SwiftUI


struct Title3Text : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.title3Font)
  }
}
struct Title3EmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.title3EmphasisFont)
  }
}

struct HeadlineText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.headlineFont)
  }
}
struct HeadlineEmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.headlineEmphasisFont)
  }
}

struct BodyText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.bodyFont)
  }
}
struct BodyEmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.bodyEmphasisFont)
  }
}

struct CalloutText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.calloutFont)
  }
}
struct CalloutEmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.calloutEmphasisFont)
  }
}

struct SubheadlineText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.subheadlineFont)
  }
}
struct SubheadlineEmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.subheadlineEmphasisFont)
  }
}

struct FootnoteText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.footnoteFont)
  }
}
struct FootnoteEmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.footnoteEmphasisFont)
  }
}

struct CaptionText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.captionFont)
  }
}
struct CaptionEmphasisText : ViewModifier {
  func body(content: Content) -> some View {
    content.font(.captionEmphasisFont)
  }
}
