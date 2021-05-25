//
//  PriceAlertView.swift
//  Cryptogenics
//
//  Created by user on 5/1/21.
//

import SwiftUI

struct PriceAlertView: View {
    @StateObject var priceAlertViewModel: PriceAlertViewModel
    @State var showAddPriceAlertPopup = false
    @State var showPriceAlertAddedView = false
    
    @State var HUD: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        if priceAlertViewModel.priceAlerts.count != 0 {
                            HStack {
                                Spacer()
                                Text("Refreshing in \(priceAlertViewModel.timerCount)")
                                    .italic()
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .padding(2)
                                Spacer()
                            }
                        }

                        ForEach(priceAlertViewModel.priceAlerts) { priceAlert in
                            PriceAlertItem(priceAlert: priceAlert, HUD: $HUD)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        
                        if priceAlertViewModel.priceAlerts.count < PriceAlertUserDefaultsStore.getLocalPriceAlerts().count {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .foregroundColor(.silver)
                                    .padding(.bottom)
                                Spacer()
                            }
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
            
            if (priceAlertViewModel.priceAlertsFetchComplete && PriceAlertUserDefaultsStore.getLocalPriceAlerts().count == 0) {
                VStack {
                    Spacer()
                    Text("Add price alerts by tapping on the\nplus sign on the top right corner")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.title3)
                    Spacer()
                }
            }
            
            if showAddPriceAlertPopup {
                AddPriceAlertView(show: $showAddPriceAlertPopup,
                                  showPriceAlertAdded: $showPriceAlertAddedView)
            }
            
            if showPriceAlertAddedView {
                withAnimation {
                    ItemAddedView(show: $showPriceAlertAddedView,
                                  text: "Added Price Alert")
                }
            }
            
            if HUD {
                HUDProgressView(placeHolder: "", isTransparent: true, show: $HUD)
                    .edgesIgnoringSafeArea(.all)
            }
            
        }
        .environmentObject(priceAlertViewModel)
        .onAppear {
            print("Price alerts: \(PriceAlertUserDefaultsStore.getLocalPriceAlerts().count)")
        }
//        .transition(.opacity)
//        .animation(.linear)
    }
}

struct PriceAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertView(priceAlertViewModel: PriceAlertViewModel())
    }
}
