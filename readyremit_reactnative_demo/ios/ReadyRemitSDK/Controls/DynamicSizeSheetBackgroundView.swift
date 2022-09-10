//
//  DynamicSizeSheetBackgroundView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI
import UIKit


struct DynamicSizeSheetBackgroundView: UIViewRepresentable {

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}
