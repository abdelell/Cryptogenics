//
//  PriceAlertViewModel.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI
import FirebaseFirestore

enum NetworkError: Error {
    case errorAddingDocument
    case invalidFallByPercentNumber
}

enum SuccessFirebase {
    case addedPriceAlert
}

class AddPriceAlertViewModel: ObservableObject {
    @Published var selectedCoin: Coin = Coin.sample
    @Published var targetPercent: String = "" {
        didSet {
            if (targetPercent.last == "." && targetPercent.split(separator: ".").count == 2) || (targetPercent.suffix(2) == ".."){
                targetPercent.removeLast(1)
                return
            }
            
            if targetPercent == "." {
                targetPercent = "0."
            }
        }
    }
    @Published var targetAmount: String = "" {
        didSet {
            if (targetAmount.last == "." && targetAmount.split(separator: ".").count == 2) || (targetAmount.suffix(2) == "..") {
                targetAmount.removeLast(1)
                return
            }
            
            if targetAmount.count > 0, targetAmount.prefix(1) != "$" {
                if targetAmount == "."{
                    targetAmount = "$0."
                } else {
                    targetAmount = "$" + targetAmount
                }
                
            } else if targetAmount == "$" {
                targetAmount = ""
            }
            
            let newValueArraySplit = targetAmount.split(separator: "$")
            
            if newValueArraySplit.count >= 2 {
                targetAmount = "$" + newValueArraySplit.joined()
            }
        }
    }
    
    @Published var selectedAlertOption: AlertOption = AlertOptions.priceRisesByPercent.getAlert()
    
    var target: Double {
        get {
            if selectedAlertOption.type == .percent {
                guard let targetPercentNum = Double(targetPercent.replacingOccurrences(of: "%", with: "")) else {
                    return 0
                }
                let percentMultiplier = targetPercentNum / 100
                
                let percentValue = (selectedCoin.priceUSD * Double(percentMultiplier))
                
                if selectedAlertOption == AlertOptions.priceRisesByPercent.getAlert() {
                    return selectedCoin.priceUSD + percentValue
                } else {
                    return selectedCoin.priceUSD - percentValue
                }
                
            } else if selectedAlertOption.type == .moneyAmount {
                guard let targetAmountNum = Double(targetAmount.replacingOccurrences(of: "$", with: "")) else {
                    return 0
                }
                
                return targetAmountNum
            }
            
            return 0.0
        }
    }
    
    func addPriceAlert(completion:@escaping (Result<SuccessFirebase, NetworkError>) -> ()) {
        if (selectedAlertOption == AlertOptions.priceFallsByPercent.getAlert()) && target <= 0.0 {
            completion(.failure(.invalidFallByPercentNumber))
            return
        }
        
        
        let deviceToken = UserDefaults.standard.object(forKey:"token") as? String ?? ""
        let db = Firestore.firestore()
        
        let priceRisesAbove = selectedAlertOption == AlertOptions.priceRisesAbove.getAlert() || selectedAlertOption == AlertOptions.priceRisesByPercent.getAlert()
        
        db.collection("alerts")
            .document(selectedCoin.contractAddress)
            .setData([
                "coinName": selectedCoin.name,
                "coinSymbol": selectedCoin.symbol
            ])
        
        
        let document = db.collection("alerts")
            .document(selectedCoin.contractAddress)
            .collection("priceAlerts")
            .document()
        
        document.setData([
            "deviceToken": deviceToken,
            "target": target,
            "priceRisesAbove": priceRisesAbove
        ]) { err in
            if let err = err {
                completion(.failure(.errorAddingDocument))
                print("Error adding document: \(err)")
            } else {
                completion(.success(.addedPriceAlert))
                addPriceAlertLocally()
                NotificationCenter.default.post(name: Notification.Name("AddedPriceAlert"), object: nil)
                print("Document added with ID: \(self.selectedCoin.contractAddress)")
            }
        }
        
        func addPriceAlertLocally() {
            let dict = [
                "contractAddress": selectedCoin.contractAddress,
                "target": target,
                "priceRisesAbove": priceRisesAbove,
                "documentID": document.documentID
            ] as [String : Any]
            
            PriceAlertUserDefaultsStore.addPriceAlertLocally(dict: dict)
        }
    }
}
