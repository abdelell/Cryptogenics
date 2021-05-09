//
//  BackgroundDismissButton.swift
//  Cryptogenics
//
//  Created by user on 5/5/21.
//

import SwiftUI

struct BackgroundDismissButton: View {
    
    @Binding var show: Bool
    
    var body: some View {
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
    }
}
