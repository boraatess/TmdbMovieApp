//
//  MovieListApi.swift
//  TmdbMovieApp
//
//  Created by bora on 8.09.2021.
//

import PromiseKit

class ListApi {
    
    private let api = BaseApi()
    
    func fetchNowPlayingMovies() -> Promise<NowPlayingResponse> {
        return api.get(url: "/movie/now_playing", parameters: nil)
    }
    
    func fetchUpComingMovies() -> Promise<UpComingResponse> {
        return api.get(url: "/movie/upcoming", parameters: nil)
    }
    
    func fetchSearchedMovie(params: SearchMovieRequest) -> Promise<SearchMovieResponse> {
        return api.get(url: "/search/movie", parameters: params.dictionary)
    }
}
