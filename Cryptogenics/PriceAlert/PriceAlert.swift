//
//  PriceAlert.swift
//  Cryptogenics
//
//  Created by user on 5/4/21.
//

import SwiftUI

struct PriceAlert: Identifiable {
    let id = UUID()
    let coin = Coin.sample
    let alertOption: AlertOption
    let target: Double
    @State var isActive: Bool
    var offset: CGFloat = 0
    var isSwiped: Bool = false
}

extension PriceAlert {
    static var sample: PriceAlert {
        return PriceAlert(alertOption: AlertOptions.priceFallsBelow.getAlert(),
                          target: 0.000000054,
                          isActive: true)
    }
}
