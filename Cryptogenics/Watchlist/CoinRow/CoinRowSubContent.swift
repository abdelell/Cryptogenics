//
//  CoinRowSubContent.swift
//  Cryptogenics
//
//  Created by user on 5/10/21.
//

import SwiftUI

struct CoinRowSubContent: View {
    
    var coin: Coin
    var showCopiedText: Bool = false
    var bscUrl: String {
        return "https://bscscan.com/token/\(coin.contractAddress)"
    }
    var poochartUrl: String {
        return "https://poocoin.app/tokens/\(coin.contractAddress)"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ShortDivider(width: 150)
            
            Button(action: {
                UIPasteboard.general.string = coin.contractAddress
                print(coin.contractAddress)
            }) {
                VStack {
                    Text("Token Address")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.silver)
                        .padding(.top, 5)
                    (Text("\(coin.contractAddress) ") +
                        Text(Image(systemName: "doc.on.doc.fill")) +
                        Text(showCopiedText ? "Copied" : ""))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            
            LinkView(title: "Chart", url: poochartUrl)
                .padding(.top, 5)
            
            LinkView(title: "Bscscan", url: bscUrl)
                .padding(.top, 5)
        }
    }
    
}

struct LinkView: View {
    
    var title: String
    var url: String
    
    var body: some View {
        Text(title)
            .bold()
            .font(.title3)
            .foregroundColor(.silver)
            .padding(.top, 5)
        URLButton(content:
                    Text(url)
                    .font(.callout)
                    .underline(true, color: .blue),
                  url: url)
            
    }
}

struct ShortDivider: View {
    
    var width: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Divider()
                    .frame(maxWidth: width)
            }
            Spacer()
        }
    }
}

struct CoinRowSubContent_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowSubContent(coin: Coin.sample)
    }
}
