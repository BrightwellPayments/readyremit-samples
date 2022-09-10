//
//  DynamicPickerField.swift
//  ReadyRemitSDK
//
//  Created by Sergio García Vargas on 02/08/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//

import SwiftUI

struct DynamicPickerField: View {
  @Binding var maf: PickerFieldValue<OptionsSet>
  @Binding var options: [OptionsSet]?
  @Binding var isLoading: Bool?

    var body: some View {
      LinePickerField(selection: options ?? [],
                      fieldValue: Binding(get: { maf },
                                          set: { maf = $0 }),
                      isLoading: Binding.constant(isLoading ?? true),
                      textToDisplay: { value in
        value.name!
      }).padding(.bottom, 15)
    }
  
  
}

#if DEBUG
struct DynamicPickerField_Previews: PreviewProvider {
  static let token = OAuthToken(tokenType: "token",
                                           accessToken: "access",
                                           expiresInSeconds: 600)
  static let tokenStore = AuthTokenStore(authToken: token)
  static let session = ApiSession(environment: ApiEnvironment.mock,
                                  authTokenStore: tokenStore)
  
    static var previews: some View {
      DynamicPickerField(maf: Binding.constant(PickerFieldValue<OptionsSet>(field: Field(
        id:"",
        label:"",
        required:true,
        placeholder:"",
        info:"",
        group:"",
        textType:"",
        minLength:0,
        maxLength:0,
        options:[],
        order: 0),
                                                                            value: nil)),
                         options: Binding.constant([]),
                         isLoading: Binding.constant(false))
    }
}
#endif
