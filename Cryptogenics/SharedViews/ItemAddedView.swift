//
//  ItemAddedView.swift
//  Cryptogenics
//
//  Created by user on 4/26/21.
//

import SwiftUI

struct ItemAddedView: View {
    
    @Binding var show: Bool
    var text: String
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
                .padding()
            Text(text)
                .foregroundColor(.gray)
                .font(.headline)
                .padding()
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
        .background(BlurView())
        .cornerRadius(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    show.toggle()
                }
            }
        }
        
    }
}
