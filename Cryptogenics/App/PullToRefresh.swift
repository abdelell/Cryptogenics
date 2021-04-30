//
//  PullToRefresh.swift
//  Cryptogenics
//
//  Created by user on 4/26/21.
//

import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("")
                }
                Spacer()
            }
            .opacity(UserDefaultsStore.getContractAddresses().count == 0 ? 0 : 1)
            .offset(y: -27)
            .scaleEffect(1.2, anchor: .center)
        }.padding(.top, -50)
    }
}
