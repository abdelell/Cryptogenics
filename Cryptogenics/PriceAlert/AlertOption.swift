//
//  AlertOption.swift
//  Cryptogenics
//
//  Created by user on 5/5/21.
//

import Foundation

enum AlertOptions: CaseIterable {
    case priceFallsBelow
    case priceRisesAbove
    case priceFallsByPercent
    case priceRisesByPercent
    
    func getAlert() -> AlertOption {
        switch self {
        case .priceFallsBelow:
            return AlertOption(title: "Price Falls Below", type: .moneyAmount)
        case .priceRisesAbove:
            return AlertOption(title: "Price Rises Above", type: .moneyAmount)
        case .priceFallsByPercent:
            return AlertOption(title: "Price Falls By Percent", type: .percent)
        case .priceRisesByPercent:
            return AlertOption(title: "Price Rises By Percent", type: .percent)
        }
    }
    
    static func getAlerts() -> [AlertOption] {
        var alerts = [AlertOption]()
        
        for alert in AlertOptions.allCases {
            alerts.append(alert.getAlert())
        }
        
        return alerts
    }
}

struct AlertOption: Hashable {
    enum Types {
        case moneyAmount
        case percent
    }
    
    var title: String
    var type: Types
}
