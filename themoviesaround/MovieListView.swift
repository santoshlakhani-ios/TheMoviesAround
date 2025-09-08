//
//  MovieListView.swift
//  themoviesaround
//
//  Created by Santosh Lakhani on 08/09/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieViewModel()
    @State private var searchText = ""
    
    var filteredMovies: [Movie] {
        guard !searchText.isEmpty else {
            return viewModel.movies
        }
        return viewModel.movies.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(filteredMovies) { movie in
                        NavigationLink(value: movie) {
                            VStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)")) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(movie.title)
                                    .font(.caption)
                                    .lineLimit(1)
                            } //: VStack
                        } //: Navigation Link
                    } //: ForEach loop
                }
                .padding()
            } //: ScrollView
            .navigationDestination(for: Movie.self, destination: { movie in
                MoviewDetailView(movie: movie)
            })
            .navigationBarTitle("Movies")
            .searchable(text: $searchText, prompt: "Search Movies")
            .task {
                await viewModel.fetchMovies()
            }
        }
    }
}

#Preview {
    MovieListView()
}
