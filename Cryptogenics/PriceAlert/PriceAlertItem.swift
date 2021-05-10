//
//  PriceAlertItem.swift
//  Cryptogenics
//
//  Created by user on 5/1/21.
//

import SwiftUI

struct PriceAlertItem: View {
    
    @State var priceAlert: PriceAlert
    @State var isActive: Bool = true {
        didSet {
            priceAlert.isActive = isActive
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation(.easeIn) {
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
                        Text("Pitbull - Pit")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Toggle("", isOn: $isActive)
                    }
                    HStack {
                        Text("Current Price:")
                        Spacer()
                        Text("$0.0000000034")
                    }
                    Divider()
                    HStack {
                        Text("Target")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("0.82% - $0.000000054")
                            .foregroundColor(.gray)
                    }
                }
                .opacity(isActive ? 1 : 0.2)
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
//        UserDefaultsStore.deleteToken(contractAddress: coin.contractAddress)
//        coinManager.coins.removeAll { (coin) -> Bool in
//            return self.coin.id == coin.id
//        }
    }
}

struct PriceAlertItem_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertItem(priceAlert: PriceAlert.sample)
    }
}
