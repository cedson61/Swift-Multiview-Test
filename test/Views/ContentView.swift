//
//  ContentView.swift
//  test
//
//  Created by Chase Edson on 12/2/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
            VStack{
                NavigationLink(destination: googleUIView()){
                    Text("Press me to go to Google")
                }
                NavigationLink(destination: weatherUIView()){
                    Text("Press me to make a Weather API call")
                        .padding()
                }
            }
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

