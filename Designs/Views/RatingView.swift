//
//  RatingView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 24/04/23.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int?
    
    private func starType(index: Int) -> String {
        if let rating = rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundColor(Color.orange)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(2))
    }
}
