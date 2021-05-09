//
//  PopupTopView.swift
//  Cryptogenics
//
//  Created by user on 5/6/21.
//

import SwiftUI

struct PopupTitle: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .bold()
            .font(.title)
            .onTapGesture {
                if UIApplication.shared.isKeyboardPresented {
                    UIApplication.shared.endEditing()
                }
            }
    }
}


//struct PopupTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopupTopView()
//    }
//}
