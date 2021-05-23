//
//  PriceAlertUserDefaultsStore.swift
//  Cryptogenics
//
//  Created by user on 5/11/21.
//

import Foundation

class PriceAlertUserDefaultsStore {
    static let defaults = UserDefaults.standard
    
    static func getLocalPriceAlerts() -> [[String: Any]] {
        let priceAlerts = defaults.object(forKey:"priceAlerts") as? [[String : Any]] ?? [[String : Any]]()
        return priceAlerts
    }
    
    static func addPriceAlertLocally(dict: [String: Any]) {
        var priceAlerts = getLocalPriceAlerts()
        priceAlerts.append(dict)
        defaults.setValue(priceAlerts, forKey: "priceAlerts")
    }
    
    static func deletePriceAlert(documentID: String) {
        let priceAlerts = getLocalPriceAlerts()
        
        let filteredPriceAlerts = priceAlerts.filter {
            guard let priceAlertDocumentID = $0["documentID"] as? String else {
                return true
            }
            
            return priceAlertDocumentID != documentID
        }
        
        defaults.setValue(filteredPriceAlerts, forKey: "priceAlerts")
    }
    
    
}
