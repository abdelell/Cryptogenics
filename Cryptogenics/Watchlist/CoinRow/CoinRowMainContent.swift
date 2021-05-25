//
//  CoinRowMainContent.swift
//  Cryptogenics
//
//  Created by user on 5/10/21.
//

import SwiftUI

struct CoinRowMainContent: View {
    
    @EnvironmentObject var coinViewModel: CoinViewModel
    @State var coin: Coin
    
    var isExpanded: Bool {
        return coinViewModel.expandedCoinContractAddress == coin.contractAddress
    }
    
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
                    PercentChange(percentChange: coin.formattedPriceChange24h, isPositive: coin.isPriceChange24hPositive)
                }
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right" )
                    .font(.body)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                    .animation(.none)
            }
            
            if coinViewModel.expandedCoinContractAddress == coin.contractAddress {
                CoinRowSubContent(coin: coin)
            }
            
            Divider()
                .background(Color.white)
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.1)) {
                coinViewModel.expandedCoinContractAddress = coinViewModel.expandedCoinContractAddress == coin.contractAddress ? "" : coin.contractAddress
            }
        }
    }
}

struct PercentChange: View {
    var percentChange: String
    var isPositive: Bool
    
    var body: some View {
        Text(percentChange)
            .padding(.vertical, 4)
            .padding(.trailing, 4)
            .padding(.leading, 12)
            .foregroundColor(.white)
            .background(isPositive ? Color.upGreenColor : Color.downRedColor)
            .font(.system(size: 15))
            .cornerRadius(4.0)
            
    }
}


struct CoinRowMainContent_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowMainContent(coin: Coin.sample)
    }
}
