//
//  AlertOptionsMenuView.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI

struct AlertOptionsMenuView: View {
    @StateObject var priceAlertViewModel: PriceAlertViewModel
    var alertOptions : [AlertOption] = AlertOptions.getAlerts()
    
    var body: some View {
        Menu {
            Button {
                priceAlertViewModel.selectedAlertOption = AlertOptions.priceRisesAbove.getAlert()
            } label: {
                Text(AlertOptions.priceRisesAbove.getAlert().title)
                Image(systemName: "arrow.up.right.circle")
            }
            .padding(5)
            
            Button {
                priceAlertViewModel.selectedAlertOption = AlertOptions.priceFallsBelow.getAlert()
            } label: {
                Text(AlertOptions.priceFallsBelow.getAlert().title)
                Image(systemName: "arrow.down.right.circle")
            }
            .padding(5)
            
            Button {
                priceAlertViewModel.selectedAlertOption = AlertOptions.priceRisesByPercent.getAlert()
            } label: {
                Text(AlertOptions.priceRisesByPercent.getAlert().title)
                Image(systemName: "arrow.up.right.circle")
            }
            .padding(5)
            
            Button {
                priceAlertViewModel.selectedAlertOption = AlertOptions.priceFallsByPercent.getAlert()
            } label: {
                Text(AlertOptions.priceFallsByPercent.getAlert().title)
                Image(systemName: "arrow.down.right.circle")
            }
            .padding(5)
            
        } label: {
            Text(priceAlertViewModel.selectedAlertOption.title)
                .padding(5)
            Image(systemName: "arrow.up.right.circle")
        }
    }
}

//struct AlertOptionsMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertOptionsMenuView()
//    }
//}
