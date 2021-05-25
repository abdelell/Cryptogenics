//
//  HUDProgressView.swift
//  Cryptogenics
//
//  Created by user on 4/26/21.
//

import SwiftUI

struct HUDProgressView: View {
    
    var placeHolder: String
    var isTransparent: Bool = false
    @Binding var show: Bool
    @State var animate = false
    
    var body: some View {
        VStack(spacing: 28) {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [Color.primary, Color.primary.opacity(0)]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                .frame(width: 80, height: 80)
                .rotationEffect(.init(degrees: animate ? 360 : 0))
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
        .background(BlurView())
        .cornerRadius(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(isTransparent ? 0.1 : 0.35)
//                .onTapGesture {
//                    withAnimation {
//                        show.toggle()
//                    }
//                }
        )
        .onAppear {
            withAnimation( Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animate.toggle()
            }
        }
    }
}

