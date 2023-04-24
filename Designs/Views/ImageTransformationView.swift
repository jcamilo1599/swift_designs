//
//  ImageTransformationView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 10/04/23.
//

import SwiftUI

struct ImageTransformationView: View {
    @State var currentImage: CustomShape = .star
    @State var pickerImage: CustomShape = .star
    @State var blurRadius: CGFloat = 0
    @State var animateMorph: Bool = false
    
    var body: some View {
        VStack {
            // Imagen
            GeometryReader{ proxy in
                let size = proxy.size
                
                Image("image-3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(x: -20, y: 40)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .mask {
                        // Transformando formas con la ayuda de Canvas y Filters (filtros)
                        Canvas{ context, size in
                            context.addFilter(.alphaThreshold(min: 0.4))
                            
                            // Hasta 20 -> Será como 0-1
                            // Después de 20, hasta 40 -> Será como 1-0
                            context.addFilter(.blur(radius: blurRadius >= 20 ? 20 - (blurRadius - 20) : blurRadius))
                            
                            context.drawLayer { ctx in
                                if let resolvedImage = context.resolveSymbol(id: 1) {
                                    ctx.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2),anchor: .center)
                                }
                            }
                        } symbols: {
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        .onReceive(Timer.publish(every: 0.007, on: .main, in: .common).autoconnect()) { _ in
                            if animateMorph {
                                if blurRadius <= 40{
                                    blurRadius += 0.5
                                    
                                    if blurRadius.rounded() == 20{
                                        // Cambio a la siguiente imagen
                                        currentImage = pickerImage
                                    }
                                }
                                
                                if blurRadius.rounded() == 40{
                                    // Finalizar animación y resetear el radio de desenfoque a cero
                                    animateMorph = false
                                    blurRadius = 0
                                }
                            }
                        }
                    }
            }
            .frame(height: 400)
            
            // Seleccionador de formato
            Picker("", selection: $pickerImage) {
                ForEach(CustomShape.allCases,id: \.rawValue){ shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .pickerStyle(.inline)
            .padding()
            .onChange(of: pickerImage) { newValue in
                animateMorph = true
            }
        }
    }
}

struct ResolvedImage: View{
    @Binding var currentImage: CustomShape
    
    var body: some View{
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 300))
            .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
            .frame(width: 300, height: 300)
    }
}

enum CustomShape: String,CaseIterable{
    case star = "star.fill"
    case star_circle = "star.circle.fill"
    case moon_stars = "moon.stars.fill"
    case person = "person.fill"
}

struct ImageTransformationView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTransformationView()
    }
}
