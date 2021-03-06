//
//  AddTokenView.swift
//  Cryptogenics
//
//  Created by user on 4/24/21.
//

import SwiftUI
import MobileCoreServices

struct AddTokenView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    @Binding var show: Bool
    @State private var showInvalidAddressAlert = false
    @State private var showAlreadyExistsAlert = false
    
    @State var tokenAddress: String = ""
    @State private var swapExchange = "PancakeSwap"
    var swapExchanges = ["PancakeSwap"]
    
    @State var HUD = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                VStack(spacing: 25) {
                    Text("Add Token")
                        .bold()
                        .font(.title)
                        .onTapGesture {
                            if UIApplication.shared.isKeyboardPresented {
                                UIApplication.shared.endEditing()
                            }
                        }
                    Picker(selection: $swapExchange, label: Text("")) {
                        ForEach(swapExchanges, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: geometry.size.width * 0.8)
                    
                    HStack {
                        TextField("Token Address...", text: $tokenAddress)
                            .disableAutocorrection(true)
                        Button(action: {
                            let pastedText = UIPasteboard.general.string ?? ""
                            
                            if pastedText.prefix(2) != "0x" {
                                showInvalidAddressAlert = true
                            } else {
                                tokenAddress = pastedText
                            }
                        }) {
                            Text("Paste")
                                .foregroundColor(.blue)
                                .padding(5)
                        }
                        .alert(isPresented: $showInvalidAddressAlert, content: {
                            Alert(title: Text("Invalid Token Address"))
                        })
                    }
                    .frame(width: geometry.size.width * 0.8)
                    
                    Button(action: {
                        
                        guard tokenAddress != "0xla illaha ila Allah" else {
                            UIPasteboard.general.string = UserDefaults.standard.object(forKey:"token") as? String ?? ""
                            tokenAddress = "Copied"
                            return
                        }
                        
                        HUD = true
                        
                        UserDefaultsStore.addCoin(tokenAddress) { (coinExistence) in
                            
                            HUD = false
                            
                            switch coinExistence {
                            case CoinExistence.alreadyInWatchlist:
                                showAlreadyExistsAlert = true
                            case .addedToWatchlist(let coin):
                                coinViewModel.coins.append(coin)
                                coinViewModel.coinAdded = coin
                                coinViewModel.showTokenAddedView = true
                                withAnimation {
                                    show.toggle()
                                }
                                
                            case .doesntExist:
                                showInvalidAddressAlert = true
                            }
                            
                        }
                    }) {
                        Text("Add to Watchlist")
                            .foregroundColor(tokenAddress.count > 0 ? Color.white : Color.gray)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 75)
                            .background(tokenAddress.count > 0 ? Color.gray : Color.darkGray)
                            .clipShape(Capsule())
                    }
                    .disabled(tokenAddress.count == 0)
                    .alert(isPresented: $showAlreadyExistsAlert, content: {
                        Alert(title: Text("Token is already in your watchlist"))
                    })
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 25)
                .background(BlurView())
                .cornerRadius(25)
                
                Button(action: {
                    withAnimation {
                        show.toggle()
                    }
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 28))
                        .foregroundColor(.silver)
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Button(action: {
                    if UIApplication.shared.isKeyboardPresented {
                        UIApplication.shared.endEditing()
                    } else {
                        withAnimation {
                            show.toggle()
                        }
                    }
                }) {
                    Color.black.opacity(0.8)
                }
            )
            
            if HUD {
                HUDProgressView(placeHolder: "", show: $HUD)
                    .edgesIgnoringSafeArea(.all)
            }
            
            
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
