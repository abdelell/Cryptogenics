//
//  CoinManager.swift
//  Cryptogenics
//
//  Created by user on 4/26/21.
//

import SwiftUI

class CoinManager: ObservableObject {
    @Published var coins = [Coin]() {
        didSet {
            numOfCoins = coins.count
        }
    }
    @Published var coinAdded: Coin?
    @Published var showAddTokenView: Bool = false
    @Published var numOfCoins = 0
    
    init() {
        numOfCoins = UserDefaultsStore.getContractAddresses().count
    }
}
