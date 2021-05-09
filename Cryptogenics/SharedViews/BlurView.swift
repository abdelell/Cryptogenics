//
//  BlurView.swift
//  Cryptogenics
//
//  Created by user on 4/26/21.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
