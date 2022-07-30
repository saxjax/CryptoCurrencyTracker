//
//  ViewController.swift
//  CryptoCurrencyTracker
//
//  Created by Jakob Skov Søndergård on 25/07/2022.
//

import UIKit

class ViewController: UIViewController {

    var coinmanager = CoinManager()

    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        coinmanager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self

    }
}

//MARK: - extensions
//MARK: - UiPickerView DataSource and Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        switch component {
            case 0:
                return coinmanager.cryptoArray.count
            case 1:
                return coinmanager.currencyArray.count
            default:
                return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return coinmanager.cryptoArray[row]
            case 1:
                return coinmanager.currencyArray[row]
            default:
                return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch component {
            case 0:
                let currencyOfSelectedRow = coinmanager.cryptoArray[row]
                coinmanager.setSelectedCryptoCurencyTo(currencyOfSelectedRow)
            case 1:
                let currencyOfSelectedRow = coinmanager.currencyArray[row]
                coinmanager.setSelectedCoinCurencyTo(currencyOfSelectedRow)
            default:
                break
        }
        coinmanager.getCoinPriceForSelectedCurrencies()

    }
}

//MARK: -CoinManager delegate
extension ViewController: CoinManagerDelegate {

    func didFailWithError(error: Error) {
        print(error)
    }

    func didUpdatePrice(_ coinManager: CoinManager, price: String, coinCurrency: String, cryptoCurrency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = coinCurrency
            self.priceLabel.text = price
            self.cryptoLabel.text = cryptoCurrency

        }

    }
}

