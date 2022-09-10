//
//  TransferReceiptView.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 4/25/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import SwiftUI


struct TransferReceiptView: View, AppearanceConsumer {
  var transfer: Transfer
  var image: UIImage = UIImage(namedSdk: "close")!
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack {
          //MARK: Transfer details
          Divider()
          VStack{
            Text(L10n.rrmTransferDetails)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(titleTextColor)
              .font(labelsFont)
            let transferDetails = transfer.quote.getTransferDetails(transferData: transfer.setTransferData())
            ForEach(transferDetails, id: \.self) { i in
              HorizontalTextView(leftLabel: i.key,
                                 value: Binding.constant(i.value),
                                 leftLabelForegroundColor: contentLabels,
                                 rightLabelForegroundColor: valueLabels)
              .padding(.top, 2)
            }
          }
          //MARK: Sender details
          VStack{
            Text(L10n.rrmSenderDetailsTitle)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(titleTextColor)
              .font(labelsFont)
            let senderDetails = transfer.senderDetails.fields
            ForEach(senderDetails, id: \.id) { i in
              HorizontalTextView(leftLabel: i.name ?? "",
                                 value: Binding.constant(""),
                                 rightLabel: labelCases(i),
                                 leftLabelForegroundColor: {contentLabels}(),
                                 rightLabelForegroundColor: valueLabels)
              .padding(.top, 2)
            }
          }
          //MARK: Recipient details
          VStack{
            Text(L10n.rrmRecipientDetailsHeader)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(titleTextColor)
              .font(labelsFont)
            let recipientDetails = transfer.recipientDetails.fields
            ForEach(recipientDetails, id: \.id) { i in
              HorizontalTextView(leftLabel: i.name ?? "",
                                 value: Binding.constant(""),
                                 rightLabel: labelCases(i),
                                 leftLabelForegroundColor: contentLabels,
                                 rightLabelForegroundColor: valueLabels)
              .padding(.top, 2)
            }
          }
          Divider()
          //MARK: Recipient bank account
          VStack{
            let accountDetails = transfer.recipientAccountDetails.fields
            if accountDetails.count > 0 {
              Text(L10n.rrmRecipientBankAccountDetails)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.top, 2)
                .foregroundColor(titleTextColor)
                .font(labelsFont)
              ForEach(accountDetails, id: \.id) { i in
                HorizontalTextView(leftLabel: i.name ?? "",
                                   value: Binding.constant(""),
                                   rightLabel: labelCases(i),
                                   leftLabelForegroundColor: contentLabels,
                                   rightLabelForegroundColor: valueLabels)
                .padding(.top, 2)
              }
            }
          }
          //MARK: Customer details
          VStack{
            Text(L10n.rrmCustomerDetails)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(titleTextColor)
              .font(labelsFont)
            let customerDetails = transfer.setCustomerDetails()
            ForEach(customerDetails, id: \.key) { i in
              HorizontalTextView(leftLabel: i.key,
                                 value: Binding.constant(""),
                                 rightLabel: i.value,
                                 leftLabelForegroundColor: contentLabels,
                                 rightLabelForegroundColor: valueLabels)
              .padding(.top, 2)
            }
          }
        //MARK: Receipt / Combined Disclousure Error Resolution
          VStack{
            Text(L10n.rrmCombinedDisclosureErrorResolution)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(titleTextColor)
              .font(labelsFont)
            
            Text(L10n.rrmYouHaveTheRight)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(contentLabels)
              .font(contentFont)
            
            Text(L10n.rrmYouCanCancel)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(contentLabels)
              .font(contentFont)
            
            Text(L10n.rrmForQuestionsOrComplaints)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(contentLabels)
              .font(contentFont)
            
            Text(L10n.rrmBankAddress)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(contentLabels)
              .font(contentFont)
            
            Text(L10n.rrmBankContactInfo)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
              .padding(.top, 2)
              .foregroundColor(contentLabels)
              .font(contentFont)
          }
        }
        .padding(.horizontal, 16)
      }
    }
    .navigationBarTitle(Text(L10n.rrmTransferReceiptTitle),
                        displayMode: .inline)
    .navigationBarItems(leading:Button(action: {
      self.presentationMode.wrappedValue.dismiss()
      }) {
        Image(uiImage: image)
          .resizable()
          .frame(width: 18, height: 18, alignment: .center)
          .padding(.leading, 14)
      }
      .buttonStyle(CallforactionButtonStyle(context: .borderless, disabled: false))
      .padding(.leading, -30)
    )
  }
  
  var titleTextColor: Color {
    Self.appearance.colors.textPrimaryShade3.color
  }
  var labelsFont: Font {
    let spec = Self.appearance.textfieldSubtitleFont
    return .font(spec: spec, style: .headline)
  }
  var contentFont: Font {
    let spec = Self.appearance.textfieldSubheadlineFont
    return .font(spec: spec, style: .subheadline)
  }
  var contentLabels: Color {
    Self.appearance.colors.textPrimaryShade1.color
  }
  var valueLabels: Color {
    Self.appearance.colors.textPrimaryShade3.color
  }
  
  func labelCases(_ i: AdditionalField) -> String {
    return {switch i.value {
    case .phoneNumber:
    let phone = i.value.getValue as! PhoneNumber
    return "(+\(phone.countryPhoneCode)) \(phone.number)"
    case .string:
    return i.value.getValue as! String
    case .int:
    return i.value.getValue as! String
  }}()
  }
}


#if DEBUG

struct TransferReceiptView_Previews: PreviewProvider {
  static var previews: some View {
    TransferReceiptView(transfer: Transfer.mock)
  }
}

#endif
