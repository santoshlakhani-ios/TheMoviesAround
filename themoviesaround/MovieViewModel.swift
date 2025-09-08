//
//  MovieViewModel.swift
//  themoviesaround
//
//  Created by Santosh Lakhani on 08/09/25.
//

import Foundation

let tmdbApiKey = "YOUR_API_KEY_HERE"

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
    
    func fetchMovies() async {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = nil
//        }
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(tmdbApiKey)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieResponse.self, from: data)
            await MainActor.run {
                self.movies = response.results
            }
        } catch {
            print(error.localizedDescription)
//            await MainActor.run {
//                self.errorMessage = error.localizedDescription
//            }
        }
        
//        await MainActor.run {
//            isLoading = false
//        }
    }
}
