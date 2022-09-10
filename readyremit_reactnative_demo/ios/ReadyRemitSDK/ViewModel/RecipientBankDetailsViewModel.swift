//
//  RecipientBankDetailsViewModel.swift
//  ReadyRemitSDK
//
//  Created by Eric Cha on 5/11/22.
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Foundation
import Combine


class RecipientBankDetailsViewModel: ObservableViewModel, RecipientBankDetailsService, DynamicApiService {
  @Published var failure: ApiFailure? = nil
  let quote: Quote
  let dstCountry: Country
  let dstCurrency: Currency
  let newRecipient: CreateRecipient
  var newRecipientAccount: RecipientAccount?
  var transferReviewVM: TransferReviewViewModel?
  let apiSession: ApiService
  var cancellables = Set<AnyCancellable>()
  @Published var recipientFieldsAccountResponse: GetRecipientFields?
  @Published var isSendDataFailure: Bool = false
  @Published var accountFields: [AnyValue] = [AnyValue]()
  @Published var banksResponse: [OptionsSet]?
  @Published var optionsSource: String?
  @Published var apiUrl: String?
  
  init(apiSession: ApiService, quote: Quote, dstCountry: Country, recipient: CreateRecipient, dstCurrency: Currency) {
    print("RecipientBankDetailsViewModel.init()")
    self.apiSession = apiSession
    self.quote = quote
    self.dstCountry = dstCountry
    self.dstCurrency = dstCurrency
    self.newRecipient = recipient
    super.init()
  }
  
  func validate() -> [String] {
    var result: [String] = []
    accountFields.forEach {
          switch $0 {
          case let a as StringValue:
            let counter = a.value.count
            let minLength = a.fieldReadonlyData.minLength
            if counter < minLength! {
              result.append(L10n.rrmErrorEmptyDynamicField(a.fieldReadonlyData.name))
              a.validate(minLength!)
              return
            }
            a.validate()
            if case .fail(_) = a.validation {
              result.append(L10n.rrmErrorEmptyDynamicField(a.fieldReadonlyData.name))
            }
          case let b as PickerFieldValue<OptionsSet>:
            if case .fail(_) = b.validation {
              result.append(L10n.rrmErrorEmptyDynamicField(b.fieldReadonlyData.name))
            }
          default:
            print("UNHANDLED")
          }
        }
    return result
  }
  
  func postRecipientAccount(success: @escaping () -> Void) {
    failure = nil
    isLoading = true
    postCreateRecipientAccount(params: parametersForApi(), id: newRecipient.recipientId)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] in
          self?.isLoading = false
          if case let .failure(error) = $0 {
            self?.failure = error
          }
        },
        receiveValue: { [weak self] recipientAccount in
          self?.newRecipientAccount = recipientAccount
          if let apiSession = self?.apiSession,
             let quote = self?.quote,
             let dstCountry = self?.dstCountry,
             let dstCurrency = self?.dstCurrency,
             let recipient = self?.newRecipient {
            self?.transferReviewVM = TransferReviewViewModel(apiSession: apiSession,
                                                             quote: quote,
                                                             dstCountry: dstCountry,
                                                             recipient: recipient,
                                                             bankDetails: recipientAccount,
                                                             dstCurrency: dstCurrency)
          }
          success()
        }
      )
      .store(in: &cancellables)
  }
  
  fileprivate func parametersForApi() -> [String:Any] {
    var dynamicFields = [[String:Any]]()
    accountFields.forEach {
      switch $0 {
      case let a as StringValue:
        dynamicFields.append(["id": a.fieldReadonlyData.id, "type": a.fieldReadonlyData.textType!, "value": a.value ])
      case let b as PickerFieldValue<OptionsSet>:
        guard let selectedValue = b.value?.name else {
          return
        }
        dynamicFields.append([
          "id": b.fieldReadonlyData.id,
          "type": b.fieldReadonlyData.textType!,
          "value": selectedValue]
        )
      default:
        print("Not validated")
      }
    }
    
    let params: [String: Any] = ["dstCountryIso3Code": dstCountry.iso3Code,
                                 "dstCurrencyIso3Code": quote.receiveAmount.currency.iso3Code,
                                 "transferMethod": Constants.bankAccountType,
                                 "fields": dynamicFields]
    return params
  }
  
  func fetchRecipientAccountFields(
    dstCountry: String,
    dstCurrency: String) {
      isLoading = true
      var url = "" {
        didSet {
          self.getBanksList(url: url)
        }
      }
      
      fetchRecipientAccountFields(dstCountry: dstCountry, dstCurrency: dstCurrency)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] in
          self?.isLoading = false
          if case let .failure(error) = $0 {
            self?.isSendDataFailure = false
            self?.failure = error
            }
          },
              receiveValue: { [weak self] recipientAccountFields in
          self?.recipientFieldsAccountResponse = recipientAccountFields
          self?.isLoading = false
          
          if self?.accountFields.count == 0 {
            for i in recipientAccountFields.fieldSets {
              let filtered = i.fields!.filter { $0.isRequired == true }
              for (index, j) in filtered.enumerated() {
                self?.apiUrl = j.optionsSource
                url = j.optionsSource ?? ""
                let fieldSetup = Field(id: j.fieldId ?? "", label: j.name ?? "", required: j.isRequired ?? true, placeholder: j.placeholderText ?? "", info: "", group: i.fieldSetName ?? "", textType: j.fieldType, minLength: j.minLength ?? 0, maxLength: j.maxLength ?? 0, options: j.options ?? [], optionsSource: j.optionsSource ?? "", order: index)
                switch j.fieldType {
                case "TEXT":
                  self?.accountFields.append(StringValue(field: fieldSetup, value: "", valueType: .dynamic, maxLength: j.maxLength ?? 0, regex: j.regex ?? ""))
                case "PHONE_NUMBER":
                  self?.accountFields.append(FieldValue<CountryCallingCodeValue>(field: fieldSetup, value: CountryCallingCodeValue()))
                case "DATE":
                  self?.accountFields.append(FieldValue<DateValue>(field: fieldSetup, value: DateValue()))
                case "DROPDOWN":
                  self?.accountFields.append(PickerFieldValue<OptionsSet>(field: fieldSetup, value: nil))
                default:
                  print("Unhandled")
                }
              }
            }
          }
        }).store(in: &cancellables)
  }
  
  func getBanksList(url: String) {
    self.isLoading = true
    if url != "" {
      fetchDynamicApi(url: url)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] in
          self?.isLoading = false
          if case let .failure(error) = $0 {
            self?.isLoading = false
            self?.failure = error
            print("Error::::: \(error)")
          }
        },
              receiveValue: { [weak self] bankList in
          self?.banksResponse = bankList
          self?.isLoading = false
        }).store(in: &cancellables)
    }
  }
}

