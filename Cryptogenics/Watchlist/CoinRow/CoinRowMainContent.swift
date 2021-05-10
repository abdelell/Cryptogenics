//
//  CoinRowMainContent.swift
//  Cryptogenics
//
//  Created by user on 5/10/21.
//

import SwiftUI

struct CoinRowMainContent: View {
    
    @EnvironmentObject var coinManager: CoinManager
    @State var coin: Coin
    
    var isExpanded: Bool {
        return coinManager.expandedCoinContractAddress == coin.contractAddress
    }
    
//    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(coin.symbol)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Text(coin.name)
                        .padding(.vertical, 1)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: 0) {
                        Text("\(coin.formattedPrice)")
                            .fontWeight(.semibold)
                    }
                }
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right" )
                    .font(.body)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                    .animation(.none)
            }
            
            if coinManager.expandedCoinContractAddress == coin.contractAddress {
                CoinRowSubContent(coin: coin)
            }
            
            Divider()
                .background(Color.white)
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.1)) {
                coinManager.expandedCoinContractAddress = coinManager.expandedCoinContractAddress == coin.contractAddress ? "" : coin.contractAddress
            }
        }
    }
}

struct CoinRowMainContent_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowMainContent(coin: Coin.sample)
    }
}
