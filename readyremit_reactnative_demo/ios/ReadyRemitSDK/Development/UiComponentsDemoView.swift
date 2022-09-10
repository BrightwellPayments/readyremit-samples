//
//  UiComponentDemoView.swift
//  ReadyRemitSDK
//
//  Copyright © 2021 Brightwell Payments, Inc. All rights reserved.
//
#if DEBUG

import SwiftUI


public struct UiComponentDemoView : View {

  public init() {}

  @State var text = ""
  @State private var selected: Int? = nil

  public var body: some View {
    ScrollView {
      VStack(spacing: 12) {
        Spacer(minLength: 20)
        Group {
          NavigationLink(destination: ColorsDemoView(),
                         tag: 1,
                         selection: $selected,
                         label: {
            Text("Colors").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: TextsDemoView(),
                         tag: 2,
                         selection: $selected,
                         label: {
            Text("Texts").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: MiscellaneousDemoView(),
                         tag: 3,
                         selection: $selected,
                         label: {
            Text("Miscellaneous").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: TextFieldsDemoView(),
                         tag: 4,
                         selection: $selected,
                         label: {
            Text("Text Inputs").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: CountryFieldsDemoView(),
                         tag: 5,
                         selection: $selected,
                         label: {
            Text("Country Dropdowns").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: CurrencyFieldsDemoView(),
                         tag: 6,
                         selection: $selected,
                         label: {
            Text("Currency Dropdowns").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: ButtonsDemoView(),
                         tag: 7,
                         selection: $selected,
                         label: {
            Text("Buttons").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: FieldInputMixedFormView(model: FieldInputMixedFormView.Model()).navigationBarTitle("Mixed Form View"),
                         tag: 8,
                         selection: $selected,
                         label: {
            Text("Mixed Form View").bold().modifier(HeadlineText())
          })
          NavigationLink(destination: LoadingStateDemoView().navigationBarTitle("Loading State"),
                         tag: 9,
                         selection: $selected,
                         label: {
            Text("Loading State").bold().modifier(HeadlineText())
          })
          Group {
            NavigationLink(destination: CardDemoView().navigationBarTitle("Card"),
                           tag: 10,
                           selection: $selected,
                           label: {
              Text("Card").bold().modifier(HeadlineText())
            })
            NavigationLink(destination: NetworkAPIErrorBannerDemoView().navigationBarTitle("Network Error Banner"),
                           tag: 11,
                           selection: $selected,
                           label: {
              Text("Network Error Banner").bold().modifier(HeadlineText())
            })
            NavigationLink(destination: ValidationErrorCardView_Previews.previews.navigationBarTitle("Validation Error Card"),
                           tag: 12,
                           selection: $selected,
                           label: {
              Text("Validation Error Card").bold().modifier(HeadlineText())
            })
            NavigationLink(destination: BottomSheetDemoView().navigationBarTitle("Bottom Sheet"),
                           tag: 13,
                           selection: $selected,
                           label: {
              Text("Bottom Sheet").bold().modifier(HeadlineText())
            })
          }
        }
      }
      .frame(maxWidth: .infinity)
      .onTapGesture { hideKeyboard() }
      .navigationBarTitle("Menu / WIP", displayMode: .inline)
    }
    .background(UIColor.Fallback.backgroundColorSecondary.color)
  }
}


struct DemoViewPreviews: PreviewProvider {

  static var previews: some View {
    UiComponentDemoView()
      .previewLayout(.sizeThatFits)
  }
}

#endif
