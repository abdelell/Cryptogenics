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
    
    @Published var selectedAlertOption: AlertOption = AlertOptions.priceRisesAbove.getAlert()
    
    var target: Double {
        get {
            if selectedAlertOption.type == .percent {
                guard let targetPercentNum = Int(targetPercent.replacingOccurrences(of: "%", with: "")) else {
                    return 0
                }
                let percentMultiplier = targetPercentNum / 100
                
                return selectedCoin.priceUSD + (selectedCoin.priceUSD * Double(percentMultiplier))
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
        let db = Firestore.firestore()
        db.collection("alerts")
            .document(selectedCoin.contractAddress)
            .collection("priceAlerts")
            .addDocument(data: [
            "deviceToken": UserDefaults.standard.object(forKey:"token") as? String ?? "",
            "target": target,
            "priceRisesAbove": selectedAlertOption.type == AlertOptions.priceRisesAbove.getAlert().type || selectedAlertOption.type == AlertOptions.priceRisesByPercent.getAlert().type
        ]) { err in
            if let err = err {
                completion(.failure(.errorAddingDocument))
                print("Error adding document: \(err)")
            } else {
                completion(.success(.addedPriceAlert))
                print("Document added with ID: \(self.selectedCoin.contractAddress)")
            }
        }
    }
}
