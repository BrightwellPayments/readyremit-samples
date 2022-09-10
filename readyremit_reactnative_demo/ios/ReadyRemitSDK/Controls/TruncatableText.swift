//
//  TruncatableText.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//

import SwiftUI

struct TruncatableText: View {
  let text: Text
  let lineLimit: Int?
  @State private var intrinsicSize: CGSize = .zero
  @State private var truncatedSize: CGSize = .zero
  let isTruncatedUpdate: (_ isTruncated: Bool) -> Void

  var body: some View {
    text
      .lineLimit(lineLimit)
      .readTextSize { size in
        truncatedSize = size
        isTruncatedUpdate(truncatedSize != intrinsicSize)
      }
      .background(
        text
          .fixedSize(horizontal: false, vertical: true)
          .hidden()
          .readTextSize { size in
            intrinsicSize = size
            isTruncatedUpdate(truncatedSize != intrinsicSize)
          }
      )
  }
}
