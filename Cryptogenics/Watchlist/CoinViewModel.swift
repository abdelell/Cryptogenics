//
//  CoinsViewModel.swift
//  Cryptogenics
//
//  Created by user on 4/23/21.
//

import Foundation

class CoinViewModel: ObservableObject {
    
    enum NetworkError: Error {
        case badURL
        case invalidCoin(contractAddress: String)
    }

    @Published var coinAdded: Coin?
    @Published var showTokenAddedView: Bool = false
    @Published var numOfCoins = 0
    @Published var expandedCoinContractAddress: String = ""
    
    @Published var coins = [Coin]()
    @Published var timerCount = 1
    
    init() {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getCoins), userInfo: nil, repeats: true)
        
        numOfCoins = UserDefaultsStore.getContractAddresses().count
    }
    
    
//    public func getCoins(completion:@escaping ([Coin]) -> ()) {
    @objc public func getCoins() {
        
        timerCount = timerCount - 1
        
        guard timerCount == 0 else {
            return
        }
        
        timerCount = 30
        
        let contracts = UserDefaultsStore.getContractAddresses()
//        let contracts = ["0xb0b924c4a31b7d4581a7f78f57cee1e65736be1d",
//                         "0xa57ac35ce91ee92caefaa8dc04140c8e232c2e50",
//                         "0x5e90253fbae4dab78aa351f4e6fed08a64ab5590",
//                         "0x2a9718deff471f3bb91fa0eceab14154f150a385",
//                         "0x3C00F8FCc8791fa78DAA4A480095Ec7D475781e2",
//                         "0xFAd8E46123D7b4e77496491769C167FF894d2ACB",
//                         "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"]
        
        for contract in contracts {
            getCoin(contractAddress: contract) { result in
                
                switch result {
                case .success(let coin):
                    if let index = coinExists(contractAddress: coin.contractAddress) {
                        // Replace new price with old price
                        self.coins[index] = coin
                    } else {
                        self.coins.append(coin)
                        sortCoins()
                    }
                case .failure(let error):
                    print("Error getting coin: \(error)")
                }
                
            }
        }
        
        func coinExists(contractAddress: String) -> Int? {
            for i in 0..<coins.count {
                if coins[i].contractAddress == contractAddress {
                    return i
                }
            }
            
            return nil
        }
        
        func sortCoins() {
            numOfCoins = coins.count

            coins.sort {
                guard let indexOfValue1 = contracts.firstIndex(of: $0.contractAddress),
                      let indexOfValue2 = contracts.firstIndex(of: $1.contractAddress) else {
                    return true
                }

                return indexOfValue1 < indexOfValue2
            }
        }

    }
    
    public func getCoin(contractAddress: String, completion:@escaping (Result<Coin, NetworkError>) -> ()) {
        guard let url = URL(string: "https://api.dex.guru/v1/tokens/\(contractAddress)-bsc") else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data, let coinJSON = try? JSONDecoder().decode(CoinJSON.self, from: data) else {
                completion(.failure(.invalidCoin(contractAddress: contractAddress)))
                return
            }
            
            let coin = Coin(contractAddress: contractAddress,
                            symbol: coinJSON.symbol,
                            name: coinJSON.name,
                            decimals: coinJSON.decimals,
                            priceUSD: coinJSON.priceUSD,
                            priceChange24h: coinJSON.priceChange24h,
                            swap: coinJSON.AMM,
                            network: coinJSON.network,
                            offset: 0,
                            isSwiped: false)
            
//            print(coin)
            
            DispatchQueue.main.async {
                completion(.success(coin))
            }
        }
        .resume()
    }
    
    
    func delete(at offsets: IndexSet) {
        coins.remove(atOffsets: offsets)
    }
    
}
