//
//  PriceAlertItem.swift
//  Cryptogenics
//
//  Created by user on 5/1/21.
//

import SwiftUI

struct PriceAlertItem: View {
    @EnvironmentObject var priceAlertViewModel: PriceAlertViewModel
    @State var priceAlert: PriceAlert
    
    @State var showDeletePriceAlertError: Bool = false
    
    @Binding var HUD: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation(.easeIn) {
                        HUD = true
                        deleteCoin()
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.red)
                        .frame(width: 50, height: 50)
                }

            }
            
            VStack {
                Group {
                    HStack {
                        Text("\(priceAlert.coin.name) - \(priceAlert.coin.symbol)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
//                        Button(action: {
//                            
//                        }) {
//                            Text("Edit")
//                        }
                    }
                    HStack {
                        Text("Current Price:")
                        Spacer()
                        Text(priceAlert.coin.formattedPrice)
                    }
                    Divider()
                    HStack {
                        Text(priceAlert.priceRisesAbove ? "Above Target" : "Below Target")
                             .foregroundColor(.gray)
                        Spacer()
                        Text("\(priceAlert.documentID)")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(red: 33/255, green: 33/255, blue: 36/255))
            .cornerRadius(15.0)
            .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 5)
            .offset(x: priceAlert.offset)
            .gesture(
                DragGesture()
                    .onChanged(onChanged(value:))
                    .onEnded(onEnded(value:))
            )
            .alert(isPresented: $showDeletePriceAlertError, content: {
                Alert(title: Text("Error deleting price alert\nPlease try again later"))
            })
        }
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if priceAlert.isSwiped {
                priceAlert.offset = value.translation.width - 90
            } else {
                priceAlert.offset = value.translation.width
            }
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation(.easeInOut(duration: 0.1)) {
            if value.translation.width < 0 {
                if -priceAlert.offset > 50 {
                    priceAlert.isSwiped = true
                    priceAlert.offset = -65
                } else {
                    priceAlert.isSwiped = false
                    priceAlert.offset = 0
                }
            } else {
                priceAlert.isSwiped = false
                priceAlert.offset = 0
            }
        }
    }
    
    func deleteCoin() {
        priceAlertViewModel.deletePriceAlert(priceAlert: priceAlert) {
            HUD = false
        } failureCompletion: {
            HUD = false
            showDeletePriceAlertError = true
        }

    }
}

//struct PriceAlertItem_Previews: PreviewProvider {
//    static var previews: some View {
////        PriceAlertItem(priceAlert: PriceAlert.sample)
//    }
//}
