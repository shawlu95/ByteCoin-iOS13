//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(_ error: Error)
    func didUpdateCoinPrice(price: String, currency: String)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = baseURL + "/" + currency + "?apiKey=" + apiKey
        performRequest(with: url, for: currency)
    }
    
    func performRequest(with urlString: String, for currency: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let price = parseJSON(safeData) {
                        let priceString = String(format: "%.2f", price)
                        self.delegate?.didUpdateCoinPrice(price: priceString, currency: currency)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decoded.rate
            return lastPrice
        } catch {
            return nil
        }
    }
}
