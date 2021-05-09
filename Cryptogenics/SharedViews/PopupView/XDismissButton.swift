//
//  XDismissButton.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI

struct XDismissButton: View {
    
    @Binding var show: Bool
    
    var body: some View {
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
}
