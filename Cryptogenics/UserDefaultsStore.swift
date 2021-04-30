//
//  UserDefaultsStore.swift
//  Cryptogenics
//
//  Created by user on 4/26/21.
//

import Foundation

enum CoinExistence {
    case alreadyInWatchlist
    case addedToWatchlist(coin: Coin)
    case doesntExist
}

class UserDefaultsStore {
    
    public enum CoinExistence {
        case alreadyInWatchlist
        case addedToWatchlist(coin: Coin)
        case doesntExist
    }
    
    static let defaults = UserDefaults.standard
    
    static func addCoinAndCheckIfItExists(_ contractAddress: String, completion:@escaping (CoinExistence) -> ()) {
        if getContractAddresses().contains(contractAddress) {
            return completion(.alreadyInWatchlist)
        } else {
            
            let group = DispatchGroup()
                group.enter()

            
            CoinViewModel().getCoin(contractAddress: contractAddress) { result in
                switch result {
                case .success(let coin):
                    var newArray = getContractAddresses()
                    newArray.append(contractAddress)
                    
                    defaults.setValue(newArray, forKey: "contractAddresses")
                    
                    completion(.addedToWatchlist(coin: coin))
                case .failure(.invalidCoin):
                    completion(.doesntExist)
                case .failure(.badURL):
                    completion(.doesntExist)
                }
                
                group.leave()
            }
            
            group.notify(queue: .main) {
                
                
                completion(.doesntExist)
            }
            
        }
    }
    
    static func getContractAddresses() -> [String] {
        return defaults.object(forKey:"contractAddresses") as? [String] ?? []
    }
}
