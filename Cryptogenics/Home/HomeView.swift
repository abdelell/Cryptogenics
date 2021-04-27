//
//  HomeView.swift
//  Cryptogenics
//
//  Created by user on 4/17/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var coinManager = CoinManager()
    @State var showAddTokenPopup = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    
                    VStack {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            apiCall().getCoins { (coins) in
                                self.coinManager.coins = coins
                            }
                        }
                        
                        ForEach(coinManager.coins) { coin in
                            CoinListRow(coin: coin)
                                .padding(.horizontal)
                        }
                        
                        if coinManager.coins.count < UserDefaultsStore.getContractAddresses().count {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .foregroundColor(.silver)
                                Spacer()
                            }
                        }
                    }
                }
                .coordinateSpace(name: "pullToRefresh")
                .navigationTitle("Your Watchlist")
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: {
                            self.showAddTokenPopup = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .onAppear() {
                    apiCall().getCoins { (coins) in
                        self.coinManager.coins = coins
                    }
                }
            }
            
            if UserDefaultsStore.getContractAddresses().count == 0 {
                VStack {
                    Spacer()
                    Text("Add Coins by Tapping on the\nPlus Sign on the Top Right Corner")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.title3)
                    Spacer()
                }
            }
            
            if showAddTokenPopup {
                AddTokenView(show: $showAddTokenPopup)
            }
            
            if coinManager.showAddTokenView {
                withAnimation {
                    TokenAddedView(show: $coinManager.showAddTokenView, coinName: coinManager.coinAdded?.name ?? "")
                }
            }
            
        }
        .environmentObject(coinManager)
        .edgesIgnoringSafeArea(.all)
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
