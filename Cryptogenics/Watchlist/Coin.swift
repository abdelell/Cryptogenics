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
    var offset: CGFloat
    var isSwiped: Bool
    
    var formattedPrice: String {
        if Int(priceUSD) > 0 {
            return "$\(priceUSD.truncate(places: 2))"
        } else {
            let stringIntegers = "\(priceUSD)".prefix(6)
            
            let numOfZerosString = "\(priceUSD)".split(separator: "-")
            
            guard numOfZerosString.count > 1,  var numOfZeros = Int(numOfZerosString[1]) else {
                return ""
            }
            
            let integers = stringIntegers.split(separator: ".").joined()
            
            numOfZeros = numOfZeros - 1
            
            return "$0.\(repeater(string: "0", withNumber: numOfZeros))\(integers)"
        }
    }
    
    var formattedPriceChange24h: String {
        let priceChange24hString = String(priceChange24h * 100)
//        let priceChange24hString = "-110.810542359431505"
        let numOfWholeNums = priceChange24hString.split(separator: ".")[0].count
        let sign = isPriceChange24hPositive ? "+" : ""
        
        return "\(sign)\(priceChange24hString.prefix(numOfWholeNums + 3))%"
    }
    
    var isPriceChange24hPositive: Bool {
        let priceChange24hString = String(priceChange24h)
        
        return priceChange24hString.prefix(1) != "-"
    }
    
    func repeater(string: String, withNumber number: Int) -> String {
        var repeatedString = String()
        
        for _ in 0..<number {
            repeatedString += string
        }
        
        return repeatedString
    }
}

extension Coin {
    static var sample: Coin {
        return Coin(contractAddress: "0xa57ac35ce91ee92caefaa8dc04140c8e232c2e50-bsc",
                    symbol: "PIT",
                    name: "Pitbull",
                    decimals: 9,
                    priceUSD: 0.0000000041,
                    priceChange24h: 0.021,
                    swap: "pancakeswap",
                    network: "bsc",
                    offset: 0,
                    isSwiped: false)
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
