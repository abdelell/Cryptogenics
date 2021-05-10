//
//  PriceAlertViewModel.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI
import Firebase

class PriceAlertViewModel: ObservableObject {
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
    @Published var target: String = "" {
        didSet {
            if (target.last == "." && target.split(separator: ".").count == 2) || (target.suffix(2) == "..") {
                target.removeLast(1)
                return
            }
            
            if target.count > 0, target.prefix(1) != "$" {
                if target == "."{
                    target = "$0."
                } else {
                    target = "$" + target
                }
                
            } else if target == "$" {
                target = ""
            }
            
            let newValueArraySplit = target.split(separator: "$")
            
            if newValueArraySplit.count >= 2 {
                target = "$" + newValueArraySplit.joined()
            }
        }
    }
    
    @Published var selectedAlertOption: AlertOption = AlertOptions.priceRisesAbove.getAlert()
    
    func addPriceAlert() {
//        Firestore.firestore().collection("")
    }
}
