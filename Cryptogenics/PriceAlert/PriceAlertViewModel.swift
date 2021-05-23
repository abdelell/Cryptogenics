//
//  PriceAlertViewModel.swift
//  Cryptogenics
//
//  Created by user on 5/11/21.
//

import SwiftUI
import FirebaseFirestore

class PriceAlertViewModel: ObservableObject {
    @Published var priceAlerts = [PriceAlert]()
    @Published var priceAlertsFetchComplete = false
    
    var priceAlertLoopNum = 0
    var numOfAlertsLocally = 0
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.addNewPriceAlertNotification(notification:)), name: Notification.Name("AddedPriceAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPriceAlertsNotification(notification:)), name: Notification.Name("RefreshPriceAlerts"), object: nil)
        syncLocalPriceAlertsWithServer()
//        getPriceAlerts()
    }
    
    func getPriceAlerts() {
        priceAlerts.removeAll()
        
        let alerts = PriceAlertUserDefaultsStore.getLocalPriceAlerts()
        
        for alert in alerts {
            addPriceAlert(alert: alert)
        }
    }
    
    func syncLocalPriceAlertsWithServer() {
        let db = Firestore.firestore()
        let priceAlerts = PriceAlertUserDefaultsStore.getLocalPriceAlerts()
        
        numOfAlertsLocally = priceAlerts.count
        priceAlertLoopNum = 0
        
        for priceAlert in priceAlerts {
            guard let contractAddress = priceAlert["contractAddress"] as? String,
                  let documentId = priceAlert["documentID"] as? String else {
                continue
            }
            
            let coin = db.collection("alerts").document(contractAddress)
            
            coin.collection("priceAlerts")
                .document(documentId)
                .getDocument { snapshot, error in
                    let data = snapshot?.data()
                    
                    if ((snapshot?.exists) == nil) || (data == nil)  {
                        PriceAlertUserDefaultsStore.deletePriceAlert(documentID: documentId)
                        print("Deleted \(documentId)")
                    }
                    print("Document id: \(documentId)")
                    
                    self.priceAlertLoopNum += 1
                    self.checkIfEndOfLoop()
                }
        }
    }
    
    func checkIfEndOfLoop() {
        priceAlertsFetchComplete = true
        
        if priceAlertLoopNum == numOfAlertsLocally {
            getPriceAlerts()
        }
    }
    
    func addPriceAlert(alert: [String: Any]) {
        guard let contractAddress = alert["contractAddress"] as? String,
              let target = alert["target"] as? Double,
              let priceRisesAbove = alert["priceRisesAbove"] as? Bool,
              let documentID = alert["documentID"] as? String
        else {
            return
        }
        
        CoinViewModel().getCoin(contractAddress: contractAddress) { result in
            switch result {
            case .success(let coin):
                let priceAlert = PriceAlert(coin: coin,
                                            priceRisesAbove: priceRisesAbove,
                                            target: target,
                                            documentID: documentID)
                
                self.priceAlerts.append(priceAlert)
            case .failure(_):
                print("Error getting price alert coin: \(documentID)")
            }
            
        }
    }
    
    @objc func addNewPriceAlertNotification(notification: Notification) {
        // Add new coin to list
        let localUpdatedAlerts = PriceAlertUserDefaultsStore.getLocalPriceAlerts()
        
        for alert in localUpdatedAlerts {
            guard let documentID = alert["documentID"] as? String else {
                continue
            }
            
            let x = priceAlerts.first {
                $0.documentID == documentID
            }
            
            if x == nil {
                addPriceAlert(alert: alert)
                break
            }
        }
    }
    
    @objc func refreshPriceAlertsNotification(notification: Notification) {
        print("ALERT: REFRESH PRICE ALERT")
        getPriceAlerts()
    }
    
    func deletePriceAlert(priceAlert: PriceAlert, successCompletion: @escaping () -> (), failureCompletion: @escaping () -> ()) {
        // Delete it from firebase
        let db = Firestore.firestore()
        db.collection("alerts")
            .document(priceAlert.coin.contractAddress)
            .collection("priceAlerts")
            .document(priceAlert.documentID).delete() { err in
            if let err = err {
                failureCompletion()
                print("Error removing price alert: \(err)")
            } else {
                self.priceAlerts = self.priceAlerts.filter {
                    $0.documentID != priceAlert.documentID
                }
                
                // Delete it locally
                PriceAlertUserDefaultsStore.deletePriceAlert(documentID: priceAlert.documentID)
                
                failureCompletion()
                
                print("Price Alert successfully removed!")
            }
                
        }
        
    }
}
