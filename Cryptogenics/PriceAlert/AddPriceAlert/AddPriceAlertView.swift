//
//  AddPriceAlertView.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI

struct AddPriceAlertView: View {
    @StateObject var priceAlertViewModel = AddPriceAlertViewModel()
    
    @Binding var show: Bool
    @State private var showErrorAlert = false
    @State private var showInvalidAddress = false
    
    @Binding var showPriceAlertAdded: Bool
    
    @State var tokenAddress: String = ""
    
    @State var isTokenValid: Bool = false
    
    @State var HUD = false
    
    @State private var swapExchange = "PancakeSwap"
    var swapExchanges = ["PancakeSwap"]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                VStack(spacing: 25) {
                    PopupTitle(title: "Add Price Alert")
                    Picker(selection: $swapExchange, label: Text("")) {
                        ForEach(swapExchanges, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    HStack {
                        TextField("Token Address...", text: $tokenAddress)
                            .disableAutocorrection(true)
                        Button(action: {
                            pasteButtonAction()
                        }) {
                            Text("Paste")
                                .foregroundColor(.blue)
                                .padding(5)
                        }
                        .alert(isPresented: $showInvalidAddress, content: {
                            Alert(title: Text("Invalid Token Address"))
                        })
                    }

                    if isTokenValid {
                        Text("\(priceAlertViewModel.selectedCoin.name) - \(priceAlertViewModel.selectedCoin.symbol)")
                            .font(.title3)
                            .bold()
                            .onTapGesture {
                                if UIApplication.shared.isKeyboardPresented {
                                    UIApplication.shared.endEditing()
                                }
                            }
                        Divider()
                        HStack {
                            Text("Current Price")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .onTapGesture {
                                    if UIApplication.shared.isKeyboardPresented {
                                        UIApplication.shared.endEditing()
                                    }
                                }
                            Spacer()
                            Text("\(priceAlertViewModel.selectedCoin.formattedPrice)")
                                .font(.body)
                                .onTapGesture {
                                    if UIApplication.shared.isKeyboardPresented {
                                        UIApplication.shared.endEditing()
                                    }
                                }
                        }
//                        .padding(2)
                        
                        AlertOptionsMenuView(priceAlertViewModel: priceAlertViewModel)

                        HStack {
                            Text("Target")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(.trailing, 30)
                                .onTapGesture {
                                    if UIApplication.shared.isKeyboardPresented {
                                        UIApplication.shared.endEditing()
                                    }
                                }
                            
                            if priceAlertViewModel.selectedAlertOption.type == .percent {
                                HStack {
                                    Spacer()
                                    TextField("0.0", text: $priceAlertViewModel.targetPercent)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .font(.body)
                                        .offset(x: 5)
                                        .padding(.vertical, 5)
                                    Text("%")
                                        .font(.callout)
                                        .foregroundColor(priceAlertViewModel.targetPercent.count > 0 ? .white : .gray)
                                }
                                
                                    
                            } else if priceAlertViewModel.selectedAlertOption.type == .moneyAmount {
                                TextField("$0.00", text: $priceAlertViewModel.targetAmount)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .font(.body)
                                    .padding(.vertical, 5)
                            }
                                
                        }
                        .padding(2)
                        Divider()
                        
                        Button(action: {
                            HUD = true
                            priceAlertViewModel.addPriceAlert { result in
                                HUD = false
                                
                                switch result {
                                case .success(_):
                                    showPriceAlertAdded = true
                                    withAnimation {
                                        show.toggle()
                                    }
                                case .failure(_):
                                    showErrorAlert = true
                                }
                            }
                        }) {
                            Text("Add Price Alert")
                                .foregroundColor(self.isTargetValid() ? Color.white : Color.gray)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 75)
                                .background(self.isTargetValid() ? Color.gray : Color.darkGray)
                                .clipShape(Capsule())
                        }
                        
                        .disabled(!self.isTargetValid())
                        .alert(isPresented: $showErrorAlert, content: {
                            Alert(title: Text("Error adding price alert\nPlease try again later"))
                        })
                    }

                }
                .padding(.vertical, 25)
                .padding(.horizontal, 25)
                .background(BlurView())
                .cornerRadius(25)
                .animation(.default)
                .frame(width: geometry.size.width * 0.9)
                
                XDismissButton(show: $show)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                BackgroundDismissButton(show: $show)
            )
            .onAppear() {
                UIPasteboard.general.string = "0xb0b924c4a31b7d4581a7f78f57cee1e65736be1d"
            }
            if HUD {
                HUDProgressView(placeHolder: "", show: $HUD)
                    .edgesIgnoringSafeArea(.all)
            }
            
        }
    }
    
    func isTargetValid() -> Bool {
        if priceAlertViewModel.selectedAlertOption.type == .moneyAmount {
            var count = priceAlertViewModel.targetAmount.count
            if priceAlertViewModel.targetAmount.contains("$") {
                count = count - 1
            }
            
            let target = priceAlertViewModel.targetAmount.split(separator: "$").joined()
            
            if let targetNum = Double(target), targetNum == 0 {
                return false
            }
            
            return count > 0
        } else {
            
            if let targetNum = Double(priceAlertViewModel.targetPercent), targetNum == 0 {
                return false
            }
            
            return priceAlertViewModel.targetPercent.count > 0
        }
    }
    
    func pasteButtonAction() {
        let pastedText = UIPasteboard.general.string ?? ""

        if pastedText.prefix(2) != "0x" {
            showInvalidAddress = true
        } else {
            tokenAddress = pastedText
        }

        HUD = true

        CoinViewModel().getCoin(contractAddress: tokenAddress) { result in

            switch result {
            case .success(let coin):
                isTokenValid = true
                priceAlertViewModel.selectedCoin = coin
            case .failure(.invalidCoin), .failure(.badURL):
                isTokenValid = false
                showInvalidAddress = true
            }

            HUD = false
        }
    }

}
