//
//  ContentView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 9/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    BorderView()
                } label: {
                    Text("Bordes")
                }
            }
            .navigationTitle("Diseños")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
