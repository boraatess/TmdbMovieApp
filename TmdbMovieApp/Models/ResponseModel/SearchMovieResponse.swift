//
//  SearchMovieResponse.swift
//  TmdbMovieApp
//
//  Created by bora on 8.09.2021.
//

import Foundation

struct SearchMovieResponse: Codable {
    let page: Int?
    let results: [SearchMovieResult]?
    let totalPages, totalResults: Int?
    let statusMesage: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case statusMesage = "status_message"
        case statusCode = "status_code"
    }
}

// MARK: - Result
struct SearchMovieResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


