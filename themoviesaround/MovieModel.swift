//
//  MovieModel.swift
//  themoviesaround
//
//  Created by Santosh Lakhani on 08/09/25.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let adult: Bool
    let backdrop_path: String?
    let release_date: String
}

struct MovieResponse: Codable {
    let results: [Movie]
}
