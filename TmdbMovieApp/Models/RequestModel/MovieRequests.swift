//
//  MovieRequests.swift
//  TmdbMovieApp
//
//  Created by bora on 8.09.2021.
//

import Foundation

struct SearchMovieRequest: Codable {
    let query: String
}

struct MovieDetailRequest: Codable {
    let movie_id: Int
}

struct SimilarMoviesRequest: Codable {
    let movie_id: Int
}
