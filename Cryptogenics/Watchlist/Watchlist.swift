//
//  Watchlist.swift
//  Cryptogenics
//
//  Created by user on 4/17/21.
//

import SwiftUI

struct Watchlist: View {
    @StateObject var coinViewModel = CoinViewModel()
    @State var showAddTokenPopup = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        if coinViewModel.coins.count != 0 {
                            HStack {
                                Spacer()
                                Text("Refreshing in \(coinViewModel.timerCount)")
                                    .italic()
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .padding(2)
                                Spacer()
                            }
                        }
                        
                        ForEach(coinViewModel.coins) { coin in
                            CoinRow(coin: coin)
                                .padding(.horizontal)
                        }
                        
                        if coinViewModel.coins.count < UserDefaultsStore.getContractAddresses().count {
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
//                    CoinViewModel().getCoins { (coins) in
//                        self.coinManager.coins = coins
//                    }
                    
                }
            }
            
            if UserDefaultsStore.getContractAddresses().count == 0 {
                VStack {
                    Spacer()
                    Text("Add coins by tapping on the\nplus sign on the top right corner")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.title3)
                    Spacer()
                }
            }
            
            if showAddTokenPopup {
                AddTokenView(show: $showAddTokenPopup)
            }
            
            if coinViewModel.showTokenAddedView {
                withAnimation {
                    ItemAddedView(show: $coinViewModel.showTokenAddedView,
                                  text: "\(coinViewModel.coinAdded?.name ?? "") Added to Watchlist")
                }
            }
            
        }
        .environmentObject(coinViewModel)
        .edgesIgnoringSafeArea(.all)
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Watchlist()
    }
}
