//
//  PriceAlert.swift
//  Cryptogenics
//
//  Created by user on 5/4/21.
//

import SwiftUI

struct PriceAlert: Identifiable {
    let id = UUID()
    let coin: Coin
    let priceRisesAbove: Bool
    let target: Double
    let documentID: String
    var offset: CGFloat = 0
    var isSwiped: Bool = false
    
    var formattedTarget: String {
        let formatPrice = FormatPrice(price: target)
        return formatPrice.formattedPrice
    }
}

extension PriceAlert {
    static var sample: PriceAlert {
        return PriceAlert(coin: Coin.sample,
                          priceRisesAbove: true,
                          target: 0.0000031,
                          documentID: "jsdjlflsdjkkjfsdkfjdhs")
    }
}
