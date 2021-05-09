//
//  PriceAlertView.swift
//  Cryptogenics
//
//  Created by user on 5/1/21.
//

import SwiftUI

struct PriceAlertView: View {
    
    @State var showAddPriceAlertPopup = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(1...5, id: \.self) { _ in
                            PriceAlertItem(priceAlert: PriceAlert.sample)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                }
                .navigationTitle("Price Alert")
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: {
                            withAnimation {
                                self.showAddPriceAlertPopup = true
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            
            if showAddPriceAlertPopup {
                AddPriceAlertView(show: $showAddPriceAlertPopup)
            }
        }
//        .transition(.opacity)
//        .animation(.linear)
    }
}

struct PriceAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertView()
    }
}
