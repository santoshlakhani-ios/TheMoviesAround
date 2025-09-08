//
//  MoviewDetailView.swift
//  themoviesaround
//
//  Created by Santosh Lakhani on 08/09/25.
//

import SwiftUI

struct MoviewDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, content: {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)")) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                
                Text(movie.title)
                    .font(.headline)
                    .bold()
                Text(movie.overview)
                    .font(.body)
            })
            .padding()
        }
        .navigationTitle("Movie Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MoviewDetailView(movie: Movie(id: 0, title: "Testing", overview: "Testing in Preview", poster_path: ""))
}
