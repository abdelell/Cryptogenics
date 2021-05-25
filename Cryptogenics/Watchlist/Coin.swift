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
        let formatPrice = FormatPrice(price: priceUSD)
        
        return formatPrice.formattedPrice
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
