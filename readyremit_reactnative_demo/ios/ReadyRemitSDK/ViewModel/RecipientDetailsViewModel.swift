//
//  RecipientDetailsViewModel.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/5/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Combine
import Foundation
import SwiftUI

class RecipientDetailsViewModel: ObservableViewModel, RecipientDetailsService {
  @Published var failure: ApiFailure? = nil
  @Published var isSendDataFailure: Bool? = false
  @Published var recipientFieldsResponse: GetRecipientFields?
  @Published var allFields: [AnyValue] = [AnyValue]()
  
  let quote: Quote
  let dstCountry: Country
  let dstCurrency: Currency
  var newRecipient: CreateRecipient? = nil
  let apiSession: ApiService
  var cancellables = Set<AnyCancellable>()
  var recipientBankDetailsViewModel: RecipientBankDetailsViewModel?
  
  init(apiSession: ApiService, quote: Quote, dstCountry: Country, dstCurrency: Currency) {
    print("RecipientDetailsViewModel.init()")
    self.apiSession = apiSession
    self.quote = quote
    self.dstCountry = dstCountry
    self.dstCurrency = dstCurrency
    super.init()
    self.isLoading = false
  }
  
  func validate() -> [String] {
    var result: [String] = []
    allFields.forEach {
          switch $0 {
          case let a as StringValue:
            a.validate()
            if case .fail(_) = a.validation {
              result.append(L10n.rrmErrorEmptyDynamicField(a.fieldReadonlyData.name))
            }
          case let b as PickerFieldValue<OptionsSet>:
            if b.value == nil {
              result.append(L10n.rrmSelectDynamicField(b.fieldReadonlyData.name))
              b.validation = .fail([L10n.rrmSelectDynamicField(b.fieldReadonlyData.name)])
            }
          case let c as FieldValue<DateValue>:
            c.validation = c.value.validate()
            if case .fail(_) = c.validation {
              result.append(L10n.rrmErrorInvalidDate)
            }
          case let d as FieldValue<CountryCallingCodeValue>:
            d.validation = d.value.validPhoneNumber
            if case .fail(_) = d.validation {
              result.append(L10n.rrmErrorEmptyDynamicField(d.fieldReadonlyData.name))
            }
          default:
            print("UNHANDLED")
          }
        }
    return result
  }
  
  
  func createRecipient(success: @escaping () -> Void) {
    failure = nil
    var fields = [[String:Any]]()
    
    allFields.forEach {
      switch $0 {
      case let a as StringValue:
        fields.append(["id": a.fieldReadonlyData.id, "type": a.fieldReadonlyData.textType!, "value": a.value ])
      case let b as FieldValue<CountryCallingCodeValue>:
        let countryPhoneCode: Int = Int(b.value.countryCallingCode!.callingCode) ?? 0
        fields.append([
          "id": Constants.phoneNumber,
          "type": Constants.phoneNumber,
          "value": [
            "countryIso3Code": dstCountry.iso3Code,
            "countryPhoneCode": countryPhoneCode,
            "number": b.value.phoneNumber]])
      case let c as PickerFieldValue<OptionsSet>:
        guard let selectedValue = c.value?.id else {
          return
        }
        fields.append([
          "id": c.fieldReadonlyData.id,
          "type": c.fieldReadonlyData.textType!,
          "value": selectedValue]
        )
      default:
        print("Not validated")
      }
    }
    
    let params: [String: Any] = ["dstCountryIso3Code": dstCountry.iso3Code,
                                 "dstCurrencyIso3Code": quote.receiveAmount.currency.iso3Code,
                                 "userType": Constants.person,
                                 "transferMethod": Constants.bankAccountType,
                                 // TODO: Temporararily hardcoded senderID will be removed in future API update
                                 "senderId": "e087b0da-6238-46e7-b749-43331451c3f6",
                                 "fields": fields]
    isLoading = true
    postCreateRecipient(params: params)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] in
          self?.isLoading = false
          if case let .failure(error) = $0 {
            self?.isSendDataFailure = true
            self?.failure = error
          }
        },
        receiveValue: { [weak self] recipient in
          self?.newRecipient = recipient
          if let apiSession = self?.apiSession,
              let quote = self?.quote,
              let dstCountry = self?.dstCountry,
              let dstCurrency = self?.dstCurrency {
            self?.recipientBankDetailsViewModel = RecipientBankDetailsViewModel(apiSession: apiSession,
                                                                                quote: quote,
                                                                                dstCountry: dstCountry,
                                                                                recipient: recipient,
                                                                                dstCurrency: dstCurrency)
          }
          success()
        }
      )
      .store(in: &cancellables)
  }
  
  func fetchRecipientFields(
    dstCountry: String,
    dstCurrency: String
  ) {
    isLoading = true
    fetchRecipientFields(dstCountry: dstCountry, dstCurrency: dstCurrency)
    .receive(on: RunLoop.main)
    .sink(
      receiveCompletion: { [weak self] in
        self?.isLoading = false
        if case let .failure(error) = $0 {
          self?.isSendDataFailure = false
          self?.failure = error
        }
      },
      receiveValue: { [weak self] recipientFields in
        self?.recipientFieldsResponse = recipientFields
        self?.isLoading = false

        if self?.allFields.count == 0 {
          for i in recipientFields.fieldSets {
            let filtered = i.fields!.filter { $0.isRequired == true }
            for (index, j) in filtered.enumerated() {
              let fieldSetup = Field(
                id: j.fieldId ?? "",
                label: j.name ?? "",
                required: j.isRequired ?? true,
                placeholder: j.placeholderText ?? "",
                info: "",
                group: i.fieldSetName ?? "",
                textType: j.fieldType,
                minLength: j.minLength ?? 0,
                maxLength: j.maxLength ?? 0,
                options: j.options ?? [],
                order: index)
              switch j.fieldType {
              case "TEXT":
                self?.allFields.append(StringValue(field: fieldSetup, value: "", valueType: .dynamic, maxLength: j.maxLength ?? 0, regex: j.regex ?? ""))
              case "PHONE_NUMBER":
                self?.allFields.append(FieldValue<CountryCallingCodeValue>(field: fieldSetup, value: CountryCallingCodeValue()))
              case "DATE":
                self?.allFields.append(FieldValue<DateValue>(field: fieldSetup, value: DateValue()))
              case "DROPDOWN":
                self?.allFields.append(PickerFieldValue<OptionsSet>(field: fieldSetup, value: nil))
              default:
                print("Unhandled")
              }
            }
          }
        }
      }
    )
    .store(in: &cancellables)
  }
  
}
