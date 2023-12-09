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
//    let baseURL = "http://localhost:8080/api/v1/greet/param"
    let baseURL = "https://shawlu95-sandbox-a6f73a3d16cd.herokuapp.com/api/greet/v1/param"
    let apiKey = "YOUR_API_KEY_HERE"

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = baseURL + "?username=" + currency
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
                    if let username = parseJSON(safeData) {
                        self.delegate?.didUpdateCoinPrice(price: username, currency: currency)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(Greet.self, from: data)
            return decoded.message
        } catch {
            return nil
        }
    }
}
