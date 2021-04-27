//
//  Coin.swift
//  Cryptogenics
//
//  Created by user on 4/23/21.
//

import SwiftUI

struct Coin: Identifiable {
    let id = UUID()
    let contractAddress: String
    let symbol: String
    let name: String
    let decimals: Int
    let priceUSD: Double
    let priceChange24h: Double
    let swap: String
    let network: String
    
    var formattedPrice: String {
        if Int(priceUSD) > 0 {
            return "$\(priceUSD.truncate(places: 2))"
        } else {
            let stringIntegers = "\(priceUSD)".prefix(3)
            
            let numOfZerosString = "\(priceUSD)".split(separator: "-")
            
            guard numOfZerosString.count > 1,  var numOfZeros = Int(numOfZerosString[1]) else {
                return ""
            }
            
            let integers = stringIntegers.split(separator: ".").joined()
            
            numOfZeros = numOfZeros - 1
            
            return "$0.\(repeater(string: "0", withNumber: numOfZeros))\(integers)"
        }
    }
    
    func repeater(string: String, withNumber number: Int) -> String {
        var repeatedString = String()
        for i in 0..<number {
            repeatedString += string
        }
        return repeatedString
    }
}


struct CoinJSON: Codable {
    let id: String
    let symbol: String
    let name: String
    let decimals: Int
    let priceUSD: Double
    let priceChange24h: Double
    let AMM: String
    let network: String
}


extension Double {
    func truncate(places : Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * Double(self))/pow(10.0, Double(places)))
    }
}
