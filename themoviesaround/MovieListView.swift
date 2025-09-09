//
//  MovieListView.swift
//  themoviesaround
//
//  Created by Santosh Lakhani on 08/09/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("⚠️ \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.movies) { movie in
                            NavigationLink(value: movie) {
                                VStack {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")")) { image in
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
                }
            } //: ScrollView
            .navigationDestination(for: Movie.self, destination: { movie in
                MoviewDetailView(movie: movie)
            })
            .navigationBarTitle("Movies")
            .searchable(text: $viewModel.searchText, prompt: "Search Movies")
            .searchSuggestions {
                ForEach(viewModel.searchHistory, id: \.self) { suggestion in
                    Button {
                        viewModel.searchText = suggestion
                    } label: {
                        Label(suggestion, systemImage: "clock.fill")
                    }
                }
            }
            .task {
                if viewModel.searchText.isEmpty {
                    await viewModel.fetchPopularMovies()
                }
            }
        }
    }
}

#Preview {
    MovieListView()
}
