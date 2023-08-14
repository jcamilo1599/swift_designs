//
//  FloatingButtonView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 26/07/23.
//

import SwiftUI

// Modelo de datos de los botones
struct ButtonModel {
    let icon: Image
    let color: Color
    let action: () -> Void
}

struct FloatingButtonView: View {
    // Estado para controlar si el botón flotante está abierto o cerrado
    @State var opened = false
    
    // Estado para almacenar el texto del botón satélite seleccionado
    @State var selectedText = ""
    
    // Propiedad computada que define los botones satélite
    private var buttons: [ButtonModel] {
        return [
            // Botón para eliminar
            ButtonModel(
                icon: Image(systemName: "trash"),
                color: .red
            ) {
                selectedText = "Eliminar"
            },
            
            // Botón para editar
            ButtonModel(
                icon: Image(systemName: "pencil"),
                color: .blue
            ) {
                selectedText = "Editar"
            },
            
            // Botón para compartir
            ButtonModel(
                icon: Image(systemName: "square.and.arrow.down"),
                color: .gray
            ) {
                selectedText = "Compartir"
            }
        ]
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Contenido ...
                
                // Vista del botón flotante con los botones satélite
                FloatingButton(
                    opened: $opened,
                    satelliteButtons: buttons
                )
                .frame(width: 80, height: 80)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding()
            }
        }
        .navigationTitle("Botón: \(selectedText)")
    }
}

struct FloatingButton: View {
    // Estado que controla si el botón flotante está abierto o cerrado
    @Binding var opened: Bool
    
    // Array que contiene los botones satélite
    var satelliteButtons: [ButtonModel]
    
    // Ángulo de rotación del botón flotante según su estado (abierto o cerrado)
    private var rotationAngle: Angle {
        opened ? Angle(degrees: 45) : Angle(degrees: 0)
    }
    
    // Opacidad de los botones satélite según el estado del botón flotante (abierto o cerrado)
    private var satelliteOpacity: Double {
        opened ? 1 : 0
    }
    
    // Radio de los botones satélite según el estado del botón flotante (abierto o cerrado)
    private var radius: CGFloat {
        opened ? 190 : 0
    }
    
    var body: some View {
        // Vista que muestra el botón principal con animaciones de expansión y contracción
        MorphingButtonView(opened: $opened)
            .background {
                // Bucle para mostrar los botones satélite en función del array de satelliteButtons
                ForEach(satelliteButtons.indices, id: \.self) { index in
                    Button {
                        // Acción que se ejecuta cuando se selecciona un botón satélite
                        opened = false
                        satelliteButtons[index].action()
                    } label: {
                        Circle()
                            .fill(satelliteButtons[index].color)
                            .frame(width: 60, height: 60)
                            .overlay {
                                satelliteButtons[index].icon
                                    .foregroundColor(.white)
                                    .font(.system(size: 26))
                                    .fontWeight(.bold)
                                    .rotationEffect(-rotationAngle(at: index))
                            }
                            .shadow(radius: 8)
                    }
                    .foregroundColor(.black)
                    .offset(x: -radius)
                    .rotationEffect(rotationAngle(at: index))
                    .opacity(satelliteOpacity)
                }
                .animation(.spring(dampingFraction: 0.7), value: opened)
            }
    }
    
    // Función para calcular la posición de un solo botón espaciado uniformemente en un arco de 90°.
    func rotationAngle(at index: Int) -> Angle {
        Angle(degrees: 90.0/Double(satelliteButtons.count-1) * Double(index))
    }
}

struct MorphingButtonView: View {
    // Estado para controlar si el botón flotante está abierto o cerrado
    @Binding var opened: Bool
    
    private let strokeWidth: CGFloat = 6
    
    // Factor de escala para la animación de expansión y contracción del botón principal
    private var scaleFactor: CGFloat {
        opened ? 0.75 : 1
    }
    
    // Ángulo de rotación del botón principal según su estado (abierto o cerrado)
    private var rotationAngle: Angle {
        opened ? Angle(degrees: 45) : Angle(degrees: 0)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let centerX = proxy.size.width/2
            let centerY = proxy.size.height/2
            
            // Círculo blanco que forma el botón principal con sombra
            Circle()
                .fill(.white)
                .shadow(radius: 10)
            
            // Izquierda: Rectángulo horizontal que se expande y contrae con animación
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.black)
                .frame(width: opened ? 30 : strokeWidth, height: strokeWidth)
                .position(x: centerX, y: centerY)
                .offset(x: opened ? 0 : -10)
            
            // Central: Rectángulo vertical que se expande y contrae con animación
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.black)
                .position(x: centerX, y: centerY)
                .frame(width: strokeWidth, height: opened ? 30 : strokeWidth)
            
            // Derecha: Rectángulo horizontal que se expande y contrae con animación
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.black)
                .frame(width: strokeWidth, height: strokeWidth)
                .position(x: centerX, y: centerY)
                .offset(x: opened ? 0 : 10)
                .opacity(opened ? 0 : 1)
        }
        .onTapGesture {
            // Acción que se ejecuta cuando se toca el botón principal
            opened.toggle()
        }
        .scaleEffect(scaleFactor)
        .rotationEffect(rotationAngle)
        .animation(.default, value: opened)
    }
}

struct FloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonView()
    }
}
