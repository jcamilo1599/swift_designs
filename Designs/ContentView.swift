//
//  ContentView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 9/04/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rating: Int?
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    BorderView()
                } label: {
                    Text("Bordes")
                }
                
                NavigationLink {
                    ImageTransformationView()
                } label: {
                    Text("Transformación de imagen")
                }
                
                NavigationLink {
                    RefreshView() {
                        VStack{
                            Rectangle()
                                .fill(.red)
                                .frame(height: 200)
                            
                            Rectangle()
                                .fill(.yellow)
                                .frame(height: 200)
                        }
                    } onRefresh: {
                        
                    }
                } label: {
                    Text("Actualizar página (adaptado a isla dinamica y anteriores)")
                }
                
                NavigationLink {
                    ShimmerView()
                } label: {
                    Text("Efecto de brillo o cargando")
                }
                
                NavigationLink {
                    RatingView(rating: $rating)
                        .onChange(of: rating) { newValue in
                            print(newValue!)
                        }
                } label: {
                    Text("Calificación")
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
