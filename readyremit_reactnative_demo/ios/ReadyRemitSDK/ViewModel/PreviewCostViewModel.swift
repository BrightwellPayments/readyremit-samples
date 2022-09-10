//
//  PreviewCostViewModel.swift
//  ReadyRemitSDK
//
//  Created by Mohan Reddy on 23/09/21.
//

import Foundation

class PreviewCostViewModel: ObservableViewModel {
    
    var rateResponse: RateResponse?
    
    func fetchRatesData(countryCode: String, currencyCode: String, amount: String, responseBlock: @escaping () -> Void) {
        
        var resource = Resource<RateResponse>(path: "transfer/rates?receiverCountryIsoCode=\(countryCode)&receiverCurrencyIsoCode=\(currencyCode)&sendAmount=\(amount)")
        resource.httpMethod = HttpMethod.get
        
        self.isLoading = true
        WebService().send(resource: resource) { result in
            self.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.rateResponse = response
                    responseBlock()
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    // TODO: Need to handle error 
                    print("Error: \(error.localizedDescription)")
                }
                break
            }
        }
    }
}
