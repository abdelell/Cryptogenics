//
//  PriceAlertView.swift
//  Cryptogenics
//
//  Created by user on 5/1/21.
//

import SwiftUI
import UserNotifications

struct PriceAlertView: View {
    @StateObject var priceAlertViewModel: PriceAlertViewModel
    @State var showAddPriceAlertPopup = false
    @State var showPriceAlertAddedView = false
    
    // Notifications Alerts
    @State private var showGettingNotificationStatusError = false
    @State private var showGoToSettingsAlert = false
    
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
                        .alert(isPresented: $showGettingNotificationStatusError, content: {
                            Alert(title: Text("Error adding price alert"),
                                  message: Text("Please try again later"))
                        })
                        
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
                            addPriceAlertButtonAction()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .alert(isPresented: $showGoToSettingsAlert, content: {
                    Alert(title: Text("Turn notification settings on"),
                          message: Text("To get notifications for your price alerts, you need to turn them on in your settings first."),
                          primaryButton: .default(Text("Open iOS Settings")) {
                            // open ios settings
                            openiOSSettings()
                          },
                          secondaryButton: .default(Text("Cancel"))
                    )
                })
                
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("will enter foreground")
            priceAlertViewModel.syncLocalPriceAlertsWithServer()
        }
//        .onAppear {
//            print("Price alerts: \(PriceAlertUserDefaultsStore.getLocalPriceAlerts().count)")
//        }
        
//        .transition(.opacity)
//        .animation(.linear)
    }
    
    func addPriceAlertButtonAction() {
        let center  = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            print("Nottif ------\nError: \(error)\nGranted: \(granted)")
            
            guard error == nil else {
                // Show error adding alert alert
                self.showGettingNotificationStatusError.toggle()
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            guard granted else {
                // Show go to settings alert
                self.showGoToSettingsAlert.toggle()
                return
            }
            
            withAnimation {
                self.showAddPriceAlertPopup = true
            }
        }
    }
    
    func openiOSSettings() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
}

struct PriceAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertView(priceAlertViewModel: PriceAlertViewModel())
    }
}
