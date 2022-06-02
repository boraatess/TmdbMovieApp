//
//  MovieDetailApi.swift
//  TmdbMovieApp
//
//  Created by bora on 8.09.2021.
//

import PromiseKit

class DetailApi {
    
    private let api = BaseApi()
    
    func fetchMovieDetail(params: MovieDetailRequest) -> Promise<MovieDetailResponse> {
        return api.get(url: "movie/movie_id", parameters: params.dictionary)
    }
    
    func fetchSimilarMovies(params: SimilarMoviesRequest) -> Promise<SimilarMoviesResponse> {
        return api.get(url: "movie/movie_id/similar", parameters: params.dictionary)
    }
}
