//
//  NetworkErrorBannerDemoView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 3/31/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
#if DEBUG

import SwiftUI


struct NetworkAPIErrorBannerDemoView: View {
  
  @State var apiFailure: ApiFailure? = ApiFailure.failure([ApiError(message: "API load/fetch failure message placeholder copy",
                                                                    description: "",
                                                                    fieldId: nil,
                                                                    code: "404")])
  
    var body: some View {
      CountryFieldsDemoView()
        .alertApiFailure($apiFailure) {
        }
    }
}

struct NetworkAPIErrorBannerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkAPIErrorBannerDemoView()
    }
}

#endif
