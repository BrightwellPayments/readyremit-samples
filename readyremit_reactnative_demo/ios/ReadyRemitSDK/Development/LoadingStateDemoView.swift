//
//  LoadingStateDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI

struct LoadingStateDemoView: View {
    var body: some View {
      CountryFieldsDemoView()
        .overlay(LoadingStateView())
    }
}

struct LoadingStateDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingStateDemoView()
    }
}

#endif
