//
//  GlassmorphismView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 10/07/23.
//

import SwiftUI

struct GlassmorphismView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.pink.opacity(0.6), Color.orange.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            buildDecorations()
            buildCard()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder private func buildDecorations() -> some View {
        Rectangle()
            .foregroundColor(Color.purple.opacity(0.4))
            .frame(width: 250, height: 250)
            .cornerRadius(50)
            .blur(radius: 20)
            .rotationEffect(.degrees(45))
            .offset(x: -180)
        
        Rectangle()
            .foregroundColor(Color.orange.opacity(0.4))
            .frame(width: 450, height: 450)
            .cornerRadius(50)
            .blur(radius: 20)
            .rotationEffect(.degrees(45))
            .offset(x: 200, y: -200)
        
        Rectangle()
            .foregroundColor(Color.pink.opacity(0.3))
            .frame(width: 450, height: 450)
            .cornerRadius(50)
            .blur(radius: 20)
            .rotationEffect(.degrees(45))
            .offset(x: 200, y: 200)
    }
    
    private func buildCard() -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("CARD TITLE")
                        .font(.headline)
                    
                    Spacer()
                    Image(systemName: "heart.fill")
                }
                .padding()
                
                Text("Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500...")
                    .font(.caption)
                    .padding(.horizontal)
                
                HStack(spacing: 0) {
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "heart")
                            .font(.system(size: 26))
                            .frame(width: 34, height: 34)
                        
                        Text("FAVORITES")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 26))
                            .frame(width: 34, height: 34)
                        
                        Text("ANSWERS")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 26))
                            .frame(width: 34, height: 34)
                        
                        Text("SHARED")
                            .font(.caption)
                    }
                    
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "chart.bar")
                            .font(.system(size: 26))
                            .frame(width: 34, height: 34)
                        
                        Text("STATISTICS")
                            .font(.caption)
                    }
                }
                .padding()
            }
            .foregroundColor(Color.black.opacity(0.8))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .padding(.horizontal, 20)
    }
}

struct GlassmorphismView_Previews: PreviewProvider {
    static var previews: some View {
        GlassmorphismView()
    }
}
