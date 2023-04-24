//
//  ShimmerView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 24/04/23.
//

import SwiftUI

struct ShimmerView: View {
    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .shimmer(.init(
                    viewColor: .white.opacity(0.4),
                    effectColor: .white,
                    blur: 5
                ))
                .frame(width: 80, height: 80)
                .background {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.orange.gradient)
                }
            
            Divider()
                .padding(.vertical, 40)
            
            HStack {
                Circle()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 12)
                        .padding(.trailing, 40)
                }
            }
            .padding(.horizontal, 20)
            .shimmer(.init(
                viewColor: .gray.opacity(0.4),
                effectColor: .white,
                blur: 22,
                speed: 3
            ))
            
            Divider()
                .padding(.vertical, 40)
            
            HStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .shimmer(.init(
                        viewColor: .gray.opacity(0.4),
                        effectColor: .orange.opacity(0.8),
                        blur: 10
                    ))
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 12)
                        .padding(.trailing, 40)
                        .shimmer(.init(
                            viewColor: .gray.opacity(0.4),
                            effectColor: .orange.opacity(0.8),
                            blur: 10
                        ))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 12)
                        .shimmer(.init(
                            viewColor: .gray.opacity(0.4),
                            effectColor: .orange.opacity(0.8),
                            blur: 10
                        ))
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerModel) -> some View {
        self.modifier(ShimmerEffectHelper(config: config))
    }
}

private struct ShimmerEffectHelper: ViewModifier {
    let config: ShimmerModel
    @State private var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
        // Oculta el contenido, así en caso de tener opacidad disminuida evitamos afectar el efecto
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.viewColor)
                    .mask { content }
                    .overlay {
                        // Efecto de brillo
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = size.height + config.blur
                            
                            Rectangle()
                                .fill(config.effectColor)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [
                                                .white.opacity(0),
                                                config.effectColor.opacity(config.effectOpacity),
                                                .white.opacity(0)
                                            ], startPoint: .top, endPoint: .bottom)
                                        )
                                        .frame(width: size.width * 2)
                                        .blur(radius: config.blur)
                                        .rotationEffect(.init(degrees: -70))
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask { content }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

struct ShimmerModel {
    var viewColor: Color
    var effectColor: Color
    var blur: CGFloat = 0
    var effectOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView()
    }
}
