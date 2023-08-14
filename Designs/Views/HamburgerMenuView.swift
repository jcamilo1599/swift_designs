//
//  HamburgerMenuView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 13/08/23.
//

import SwiftUI

struct HamburgerMenuView: View {
    @State var isRotating = false
    @State var isHiddenMedium = false
    
    var body: some View {
        VStack(spacing: 14) {
            Rectangle()
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(
                    isRotating ? Angle(degrees: 48) : Angle(degrees: 0),
                    anchor: .leading
                )
            
            Rectangle()
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .scaleEffect(
                    x: isHiddenMedium ? 0 : 1,
                    y: isHiddenMedium ? 0 : 1,
                    anchor: .leading
                )
                .opacity(isHiddenMedium ? 0 : 1)
            
            Rectangle()
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(
                    isRotating ? Angle(degrees: -48) : Angle(degrees: 0),
                    anchor: .leading
                )
        }
        .padding()
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                isRotating.toggle()
                isHiddenMedium.toggle()
            }
        }
    }
}

struct HamburgerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HamburgerMenuView()
    }
}
