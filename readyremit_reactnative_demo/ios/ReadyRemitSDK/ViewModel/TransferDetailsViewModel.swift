//
//  TransferDetailsViewModel.swift
//  ReadyRemitSDK
//
//  Copyright © 2022 Brightwell. All rights reserved.
//
import Combine


class TransferDetailsViewModel: ObservableViewModel, TransferDetailsService {
  let apiSession: ApiService
  let delayInterval = 0.8
  @Published var countries = [Country]()
  @Published var countriesList = [Country]()
  @Published var isLoadingDstCounties: Bool = false
  @Published var isLoadingCorridors: Bool = false
  @Published var isCountrySelected: Bool = false
  @Published var countrySelected: String = ""
  @Published var corridors: [Corridor]?
  @Published var recipientData: CreateRecipient?
  
  private var dstCountryIsoCode = ""
  @Published var selectedDstCountryFieldValue
  = PickerFieldValue<Country>(field: Field(id: UUID().uuidString,
                                     label: L10n.rrmRecipientNewDestinationCountry,
                                     required: true,
                                     placeholder: L10n.rrmRecipientNewDestinationCountry,
                                     info: ""),
                        value: nil)
  @Published var selectedDstCurrencyValue
  = FieldValue<CurrencyAmountValue>(field: Field(id: UUID().uuidString,
                                                 label: L10n.rrmReceiveAmount,
                                                 required: false,
                                                 placeholder: L10n.rrmReceiveAmount,
                                                 info: ""),
                                    value: CurrencyAmountValue())
  @Published var selectedSrcCurrencyValue
  = FieldValue<CurrencyAmountValue>(field: Field(id: UUID().uuidString,
                                                 label: L10n.rrmSendAmount,
                                                 required: false,
                                                 placeholder: L10n.rrmSendAmount,
                                                 info: ""
                                                ),
                                    value: CurrencyAmountValue(currency: Currency(name: L10n.rrmCommonSourceCountryName,
                                                                                  iso3Code: Constants.usdIso3Code,
                                                                                  symbol: Constants.usdSymbol,
                                                                                  decimalPlaces: Constants.sourceCurrencyDecimalPlaces),
                                                               customErrorMessage: L10n.rrmErrorAmountRequired))
  @Published var selectedTransferTypeFieldValue
  = PickerFieldValue<TransferType>(field: Field(id: UUID().uuidString,
                                          label: L10n.rrmTransferType,
                                          required: true,
                                          placeholder: L10n.rrmTransferType,
                                          info: ""),
                             value: nil)
  @Published var transferTypes = [TransferType]()
  var quote: Quote?
  @Published var transferRate: String = "-"
  @Published var transferFee: String = "-"
  @Published var totalCost: String = "-"
  @Published var failure: ApiFailure? = nil
  var recipientDetailsViewModel: RecipientDetailsViewModel?
  var cancellables = Set<AnyCancellable>()
  
  init(apiSession: ApiService) {
    self.apiSession = apiSession
    super.init()
    self.isLoading = false
    selectedDstCurrencyValue.objectWillChange
      .receive(on: RunLoop.main)
      .sink { [weak self] in
        self?.objectWillChange.send() }
      .store(in: &cancellables)

    selectedDstCountryFieldValue.$value
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] country in
        if let country = country, let isoCode = self?.dstCountryIsoCode {
          if isoCode.isEmpty {
            self?.dstCountryIsoCode = country.iso3Code
            self?.getCorridors()
          } else if (isoCode != country.iso3Code) {
            self?.restoreData(true) { _ in
              self?.dstCountryIsoCode = country.iso3Code
              self?.getCorridors()
            }
          }
        }
      }).store(in: &cancellables)
    
    selectedSrcCurrencyValue.$value
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] currencyAmountValue in
        if currencyAmountValue.didChange {
          currencyAmountValue.didChange = false
          if currencyAmountValue.amount.isEmpty {
            self?.isLoading = false
            self?.clearQuote()
          } else {
            self?.sendAmountReceived(currencyAmountValue.amount)
          }
        }
      }).store(in: &cancellables)
  }
  
  func validate() -> [String] {
    var result: [String] = []
    selectedSrcCurrencyValue.validation = selectedSrcCurrencyValue.value.validate()
    if case .fail(_) = selectedSrcCurrencyValue.validation {
      result.append(selectedSrcCurrencyValue.fieldReadonlyData.name)
    }
    selectedDstCurrencyValue.validation = selectedDstCurrencyValue.value.validate()
    if case .fail(_) = selectedDstCurrencyValue.validation {
      result.append(selectedDstCurrencyValue.fieldReadonlyData.name)
    }
    return result
  }

  func reload() {
    transferTypes.removeAll()
    clearQuote()
    countries.removeAll()
    transferRate = "-"
    isLoading = false
    isLoadingDstCounties = false
    isLoadingCorridors = false
    dstCountryIsoCode = ""
    selectedTransferTypeFieldValue.value = nil
    selectedSrcCurrencyValue.value.amount = ""
    selectedSrcCurrencyValue.validation = .none
    selectedDstCurrencyValue.value.currency = nil
    selectedDstCurrencyValue.validation = .none
    selectedDstCurrencyValue.value = CurrencyAmountValue()
    getCorridors()
    load()
    
    let countrySelectedValue: String = UserDefaults.standard.string(forKey: "countrySelectedForDropdown")!
    if !countrySelectedValue.isEmpty {
      getTransferTypes()
    }
  }
  
  func restoreData(_ isInitial: Bool = false, completionHandler: @escaping(Bool) -> Void) {
    UserDefaults.standard.set("", forKey: "countrySelectedForDropdown")
    transferTypes.removeAll()
    clearQuote()
    isInitial ? () : countries.removeAll()
    corridors = nil
    transferRate = "-"
    if !isInitial {
      isLoading = false
      isLoadingDstCounties = false
      isLoadingCorridors = false
      selectedDstCountryFieldValue.value = nil
    }
    self.dstCountryIsoCode = ""
    
    selectedTransferTypeFieldValue.value = nil
    selectedSrcCurrencyValue.value.amount = ""
    selectedSrcCurrencyValue.validation = .none
    selectedDstCurrencyValue.value.currency = nil
    selectedDstCurrencyValue.validation = .none
    selectedDstCurrencyValue.value = CurrencyAmountValue()
    
    selectedTransferTypeFieldValue.value = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
      completionHandler(true)
    }
  }
  
  func clearQuote() {
    quote = nil
    selectedDstCurrencyValue.value.amount = ""
    transferFee  = "-"
    totalCost = "-"
  }
  
  func retry() {
    failure = nil
    if countries.isEmpty {
      load()
    }else if !selectedSrcCurrencyValue.value.amount.isEmpty {
      startQuote(sendAmount: selectedSrcCurrencyValue.value.amount){_ in }
    }
  }
  
  func getRecipientData(recipientId: String) {
    isLoading = true
    return getRecipient(recipientId: recipientId)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: {
          if case let .failure(error) = $0 {
            print("ERROR: \(error)")
            self.isLoading = false
          }
        },
        receiveValue: {[weak self] in
          self?.recipientData = $0
          self?.isLoading = false
        }
      ).store(in: &cancellables)
  }
  
  func load() {
    if countries.isEmpty {
      isLoadingDstCounties = true
      return getCountries()
        .receive(on: RunLoop.main)
        .sink(
          receiveCompletion: { [weak self] in
            if case .failure(_) = $0 {
              self?.isLoadingDstCounties = false
            }
          },
          receiveValue: { [weak self] in
            self?.countriesList = $0
            let csv: String = UserDefaults.standard.string(forKey: "countrySelectedForDropdown")!
            self?.countries = !csv.isEmpty ? $0.filter { $0.name == csv } : $0
            self?.isLoadingDstCounties = false
            self?.getTransferTypes()
          })
        .store(in: &cancellables)
    }
  }
  
  func getCorridors() {
    if corridors == nil {
      isLoadingCorridors = true
      isLoadingDstCounties = true
      return getCorridor(dstCountryIsoCode: dstCountryIsoCode)
        .receive(on: RunLoop.main)
        .sink(
          receiveCompletion: { [weak self] in
            if case let .failure(error) = $0 {
              self?.isLoadingCorridors = false
              self?.failure = error
            }
          },
          receiveValue: { [weak self] in
            self?.isLoadingCorridors = false
            self?.corridors = $0
            self?.getTransferTypes()
            self?.isLoadingDstCounties = false
          })
        .store(in: &cancellables)
    }
  }
  
  func getTransferTypes() {
    transferTypes = [TransferType(name: TransferType.TransferName.bankTransfer,
                                  id: TransferType.TransferId.bankTransfer)]
    DispatchQueue.main.asyncAfter(deadline: .now() + delayInterval) {
      self.startQuote(sendAmount: "3500", true){ response in
        if !response {
          self.getTransferTypes()
        }
      }
    }
  }
  
  func sendAmountReceived(_ sendAmount: String) {
    Timer.scheduledTimer(withTimeInterval: delayInterval, repeats: false) { [weak self] _ in
      let converted = self!.intStringified(amount: sendAmount)
      
      if self?.selectedSrcCurrencyValue.value.amount == sendAmount {
        self?.startQuote(sendAmount: converted){ _ in }
      }
    }
  }
  
  fileprivate func intStringified(amount: String) -> String {
    let decConverted = Decimal(string: amount)
    let decConvertedPoint = decConverted! * 100
    let intConverted = NSDecimalNumber(decimal: decConvertedPoint).intValue
    let str = String(intConverted)
    return str
  }
  
  func startQuote(sendAmount: String, _ isFirstLoad: Bool = false, response: @escaping (Bool) -> Void) {
    if let srcCurrency = selectedSrcCurrencyValue.value.currency,
       let dstCurrency = selectedDstCurrencyValue.value.currency,
       let dstCountry = selectedDstCountryFieldValue.value {
      let params = ["dstCountryIso3Code": dstCountry.iso3Code,
                    "dstCurrencyIso3Code": dstCurrency.iso3Code,
                    "srcCurrencyIso3Code": srcCurrency.iso3Code,
                    "transferMethod": Constants.bankAccountType,
                    "quoteBy": Quote.QuoteType.sendAmount.rawValue,
                    "amount": sendAmount
      ]
      isLoading = true
      getQuote(params: params)
        .receive(on: RunLoop.main)
        .sink(
          receiveCompletion: { [weak self] in
            if case let .failure(error) = $0 {
              print("ERROR: \(error)")
              response(false)
              self?.isLoading = false
            }
          },
          receiveValue: { [weak self] quote in
            response(true)
            if let apiSession = self?.apiSession {
              self?.quote = quote
              self?.transferFee = quote.getTransferFee(decimalPlaces: srcCurrency.decimalPlaces)
              self?.transferRate = quote.getRate()
              self?.totalCost = quote.getTotalCost(decimalPlaces: srcCurrency.decimalPlaces)
              self?.selectedDstCurrencyValue.value.amount = quote.getReceiveAmount(decimalPlaces: dstCurrency.decimalPlaces)
              self?.isLoading = false
              if isFirstLoad {
                self?.clearQuote()
              }
              self?.recipientDetailsViewModel = RecipientDetailsViewModel(apiSession: apiSession, quote: quote, dstCountry: dstCountry, dstCurrency: dstCurrency)
            }
          }
        )
        .store(in: &cancellables)
    }
  }
}
