//
//  AlertApiFailure.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell. All rights reserved.
//
import SwiftUI


struct AlertApiFailure : ViewModifier {

  var failure: Binding<ApiFailure?>

  func body(content: Content) -> some View {
    content.alert(item: failure, content: alert)
  }

  func alert(failure: ApiFailure) -> Alert {
    let dismiss = ActionSheet.Button.default(Text(L10n.rrmCommonOk)) {}
    return Alert(title: Text(failure.title),
                 message: Text(failure.message),
                 dismissButton: dismiss)
  }
}
