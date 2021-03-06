//
//  CoinRow.swift
//  Cryptogenics
//
//  Created by user on 4/23/21.
//

import SwiftUI

struct CoinRow: View {
    
    @EnvironmentObject var coinViewModel: CoinViewModel
    @State var coin: Coin
    
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
            
            CoinRowMainContent(coin: coin)
            .background(Color.black)
            .offset(x: coin.offset)
            .gesture(
                DragGesture()
                    .onChanged(onChanged(value:))
                    .onEnded(onEnded(value:))
            )

        }
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if coin.isSwiped {
                coin.offset = value.translation.width - 90
            } else {
                coin.offset = value.translation.width
            }
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation(.easeInOut(duration: 0.1)) {
            if value.translation.width < 0 {
                if -coin.offset > 50 {
                    coin.isSwiped = true
                    coin.offset = -65
                } else {
                    coin.isSwiped = false
                    coin.offset = 0
                }
            } else {
                coin.isSwiped = false
                coin.offset = 0
            }
        }
    }
    
    func deleteCoin() {
        UserDefaultsStore.deleteToken(contractAddress: coin.contractAddress)
        coinViewModel.coins.removeAll { (coin) -> Bool in
            return self.coin.id == coin.id
        }
    }
}
