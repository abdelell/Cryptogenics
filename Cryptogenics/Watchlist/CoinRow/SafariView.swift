//
//  SafariView.swift
//  Cryptogenics
//
//  Created by user on 5/10/21.
//

import SafariServices
import SwiftUI

struct URLButton<Content: View>: View {
    // What to display on the buton/ the link
    var content: Content
    var url: String
    
    @AppStorage("LinkDestination") var linkDestination = 0
    
    @State var showSafariView = false
    
    // Use this to explicitly open the url in Safari. With iOS 14 the user can change the default browser.
    var safariURL: String {
        if url.contains("https://") {
            return url.replacingOccurrences(of: "https://", with: "x-web-search://")
        } else if url.contains("http://") {
            return url.replacingOccurrences(of: "http://", with: "x-web-search://")
        } else {
            return "x-web-search://\(url)"
        }
    }
    
    @ViewBuilder var body: some View {
        switch linkDestination {
        case 0:
            // A button, that toggles a full screen cover with a SFSafariViewController
            Button(action: {
                showSafariView = true
            }) {
                content.fullScreenCover(isPresented: $showSafariView) {
                    SafariView(url: URL(string: url)!).edgesIgnoringSafeArea(.all)
                }
            }
        case 1:
            // Opens the URL in Safari
            Link(destination: URL(string: safariURL)!) {
                content
            }
        default:
            content
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    var url: URL
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariView = SFSafariViewController(url: url)
        return safariView
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }
}
