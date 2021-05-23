//
//  TabBarView.swift
//  Cryptogenics
//
//  Created by user on 5/1/21.
//

import SwiftUI

enum Tab {
    case schedule
    case announcements
}

struct TabBarView: View {

    var body: some View {
        TabView {
            Watchlist()
                .tabItem {
                    Image(systemName: "star")
                    Text("Watchlist")
                }
                .navigationBarHidden(true)
            NavigationView {
                PriceAlertView(priceAlertViewModel: PriceAlertViewModel())
                    
                    .navigationBarHidden(true)
            }
                .tabItem {
                    Image(systemName: "alarm")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Price Alert")
                }
                .navigationBarHidden(true)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
