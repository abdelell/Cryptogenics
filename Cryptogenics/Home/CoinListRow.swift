//
//  CoinListRow.swift
//  Cryptogenics
//
//  Created by user on 4/23/21.
//

import SwiftUI

struct CoinListRow: View {
    
    var coin: Coin
    
    var body: some View {
        VStack {
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
                    
                    PercentChange()
                }
            }
            Divider()
        }
        
    }
}

struct PercentChange: View {
    
    var body: some View {
        Text("-9.04%")
            .padding(.vertical, 2)
            .padding(.trailing, 4)
            .padding(.leading, 12)
            .foregroundColor(.white)
            .background(Color.downRedColor)
            .font(.system(size: 15))
            .cornerRadius(4.0)
    }
    
}

//struct CoinListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CoinListRow(coin: Coin()
//    }
//}
