//
//  CoinManager.swift
//  CryptoCurrencyTracker
//
//  Created by Jakob Skov Søndergård on 30/07/2022.
//

import Foundation
protocol CoinManagerDelegate {
    func didFailWithError(error:Error)
    func didUpdatePrice(_ coinManager:CoinManager, price:String, coinCurrency:String, cryptoCurrency:String)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    var LastLookedupCurrency:CoinData?

    let cryptoBaseUrl = "https://rest.coinapi.io/v1/exchangerate"
    let coinAPIKey = ""
    var cryptoName = "BTC"
    var moneyCurrencyName = "USD"
    var finalUrl: URL? {return URL(string: "\(cryptoBaseUrl)/\(cryptoName)/\(moneyCurrencyName)?apikey=\(coinAPIKey)")}

    let currencyArray = ["AUD", "BRL","CAD","CNY","DKK","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let cryptoArray = ["BTC","ETC","DOGE"]

    //MARK: - public

    mutating func setSelectedCryptoCurencyTo(_ currency:String){
        cryptoName = currency
    }
    mutating func setSelectedCoinCurencyTo(_ currency:String){
        moneyCurrencyName = currency
    }

    func getCoinPriceForSelectedCurrencies(){
        performRequest(with: finalUrl)
    }


//    MARK: - private
    private func performRequest(with InputUrl:URL?){
        if let url = InputUrl{
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data,response,error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let currencyInfo = self.parseJSON(safeData){

                        self.delegate?.didUpdatePrice(self, price:String(format: "%.4f", currencyInfo.rate), coinCurrency: currencyInfo.asset_id_quote, cryptoCurrency: currencyInfo.asset_id_base )
                    }
                }

            }
            task.resume()
        }
    }

    private func parseJSON(_ data:Data)->CoinData?{
        let decoder = JSONDecoder()

        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }

}
