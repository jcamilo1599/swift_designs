//
//  BorderView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 9/04/23.
//

import SwiftUI

struct BorderView: View {
    var body: some View {
        VStack {
            Text("Button 1")
                .foregroundColor(.orange)
                .padding()
                .border(.orange, width: 1)
                .padding(.bottom, 10)
            
            Text("Button 2")
                .foregroundColor(.orange)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.orange, lineWidth: 1)
                )
                .padding(.bottom, 10)
            
            Text("Button 3")
                .foregroundColor(.orange)
                .padding()
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(
                            .orange,
                            style: StrokeStyle(lineWidth: 2, dash: [8])
                        )
                )
        }
    }
}

struct BorderView_Previews: PreviewProvider {
    static var previews: some View {
        BorderView()
    }
}
