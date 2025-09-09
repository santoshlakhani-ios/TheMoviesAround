//
//  MovieViewModel.swift
//  themoviesaround
//
//  Created by Santosh Lakhani on 08/09/25.
//

import Foundation
import Combine

let tmdbApiKey = "YOUR_API_KEY_HERE"

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var searchHistory: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let historyKey: String = "searchHistory"
    private let historyLimit: Int = 10
    
    init() {
        loadSearchHistory()
        
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.handleSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func handleSearch(query: String) async {
        if query.isEmpty {
            await fetchPopularMovies()
        } else {
            await searchMovies(query: query)
            saveSearchQuery(query)
        }
    }
    
    func fetchPopularMovies() async {
        await fetchMovies(from: "https://api.themoviedb.org/3/movie/popular?api_key=\(tmdbApiKey)")
    }
    
    private func searchMovies(query: String) async {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(tmdbApiKey)&query=\(encoded)"
        await fetchMovies(from: urlString)
    }
    
    func fetchMovies(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            return
        }
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
                
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieResponse.self, from: data)
            await MainActor.run {
                self.movies = response.results
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    private func loadSearchHistory() {
        if let savedHistory = UserDefaults.standard.stringArray(forKey: historyKey) {
            searchHistory = savedHistory
        }
    }
    
    private func saveSearchQuery(_ query: String) {
        var history = searchHistory
        if let index = history.firstIndex(of: query) {
            history.remove(at: index)
        }
        history.insert(query, at: 0)
        
        if history.count >= historyLimit {
            history.removeLast()
        }
        
        searchHistory = history
        UserDefaults.standard.set(history, forKey: historyKey)
    }
}
