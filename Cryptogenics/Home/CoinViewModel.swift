//
//  CoinsViewModel.swift
//  Cryptogenics
//
//  Created by user on 4/23/21.
//

import Foundation

class CoinViewModel {
    
    enum NetworkError: Error {
        case badURL
        case invalidCoin
    }
    
    public func getCoins(completion:@escaping ([Coin]) -> ()) {
        let contracts = UserDefaultsStore.getContractAddresses()
//        let contracts = ["0xb0b924c4a31b7d4581a7f78f57cee1e65736be1d",
//                         "0xa57ac35ce91ee92caefaa8dc04140c8e232c2e50",
//                         "0x5e90253fbae4dab78aa351f4e6fed08a64ab5590",
//                         "0x2a9718deff471f3bb91fa0eceab14154f150a385",
//                         "0x3C00F8FCc8791fa78DAA4A480095Ec7D475781e2",
//                         "0xFAd8E46123D7b4e77496491769C167FF894d2ACB",
//                         "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"]
        
        var coins = [Coin]() {
            didSet {
                coins.sort {
                    guard let indexOfValue1 = contracts.firstIndex(of: $0.contractAddress),
                          let indexOfValue2 = contracts.firstIndex(of: $1.contractAddress) else {
                        return true
                    }
                    
                    return indexOfValue1 < indexOfValue2
                }
            }
        }
        
        
        for contract in contracts {
            getCoin(contractAddress: contract) { result in
                
                switch result {
                case .success(let coin):
                    coins.append(coin)
                    DispatchQueue.main.async {
                        completion(coins)
                    }
                case .failure(let error):
                    print("Error getting coin: \(error) error")
                }
                
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
                completion(.failure(.invalidCoin))
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
    
}
