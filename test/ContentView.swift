//
//  ContentView.swift
//  test
//
//  Created by Chase Edson on 12/2/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(url: "https://google.com")
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .background(Color.red)
                        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
