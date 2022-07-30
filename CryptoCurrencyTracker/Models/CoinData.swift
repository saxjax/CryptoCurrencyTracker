//
//  CoinData.swift
//  CryptoCurrencyTracker
//
//  Created by Jakob Skov Søndergård on 30/07/2022.
//

import Foundation
struct CoinData:Codable {
    let asset_id_base :String
    let asset_id_quote:String
    let rate: Double
    let time:String
}
