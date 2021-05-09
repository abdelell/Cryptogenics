//
//  PopupSubmitButton.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI

struct PopupSubmitButton: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .padding(.vertical, 10)
            .padding(.horizontal, 75)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}
