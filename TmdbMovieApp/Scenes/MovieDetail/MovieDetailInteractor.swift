//
//  MovieDetailInteractor.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import Foundation
import PromiseKit

class MovieDetailInteractor {
    var presenter: MovieDetailInteractorOutputProtocol!
    private let detailApi: DetailApi

    init(detailApi: DetailApi) {
        self.detailApi = detailApi
    }
    
    convenience required init () {
        self.init(detailApi: DetailApi())
    }
}

extension MovieDetailInteractor: MovieDetailInteractorInputProtocol {
    func fetchSelectedMovieDetailsAndSimilarMovies(id: Int) {
        let movieDetailParams = MovieDetailRequest(movie_id: id)
        let similarMoviesParams = SimilarMoviesRequest(movie_id: id)
        
        firstly {
            when(fulfilled: detailApi.fetchMovieDetail(params: movieDetailParams),
                 detailApi.fetchSimilarMovies(params: similarMoviesParams))
        }.done { [unowned self] movieDetailResponse, similarMovieResponse in
            presenter.selectedMovieDetailAndSimilarMoviesResponse(movieDetailResponse: movieDetailResponse,
                                                                  similarMoviesResponse: similarMovieResponse)
        }.catch { [unowned self] error in
            self.presenter.errorResponse(error: error)
        }
    }
}
