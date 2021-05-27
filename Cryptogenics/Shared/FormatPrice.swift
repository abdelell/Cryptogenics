//
//  FormatPrice.swift
//  Cryptogenics
//
//  Created by user on 5/24/21.
//

import SwiftUI

struct FormatPrice {
    let price: Double
    
    var formattedPrice: String {
        if Int(price) > 0 {
            return "$\(price.truncate(places: 2))"
        } else {
            var stringIntegers = "\(price)".prefix(6)
            
            let intsBeforeE = "\(price)".split(separator: "e")[0]
            
            if intsBeforeE.count < 6 {
                stringIntegers = "\(price)".prefix(intsBeforeE.count)
            }
            
            if !"\(price)".contains("-") {
                return "$\(stringIntegers)"
            }
            
            let numOfZerosString = "\(price)".split(separator: "-")
            
            guard numOfZerosString.count > 1,  var numOfZeros = Int(numOfZerosString[1]) else {
                return ""
            }
            
            let integers = stringIntegers.split(separator: ".").joined()
            
            numOfZeros = numOfZeros - 1
            
            return "$0.\(repeater(string: "0", withNumber: numOfZeros))\(integers)"
        }
    }
    
    private func repeater(string: String, withNumber number: Int) -> String {
        var repeatedString = String()
        
        for _ in 0..<number {
            repeatedString += string
        }
        
        return repeatedString
    }
}
