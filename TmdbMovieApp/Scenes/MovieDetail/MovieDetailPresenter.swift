//
//  MovieDetailPresenter.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import Foundation

class MovieDetailPresenter: NSObject {
    
    var view: MovieDetailViewProtocol!
    var interactor: MovieDetailInteractorInputProtocol!
    var router: MovieDetailRouterProtocol!
    
    private let movieId: Int
    private var movieDetailResponse: MovieDetailResponse?
    private var similarMoviesResponse: SimilarMoviesResponse?
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init()

    }

}

extension MovieDetailPresenter: MovieDetailPresenterProtocol {
    func showMovieInImdb() {
        guard let imdbId = movieDetailResponse?.imdbID else { return }
        router.showMovieInImdb(imdbId: imdbId)
    }
    
    func selectedSimilarMovieIndex(indexPath: IndexPath) {
        guard let selectedMovieId = similarMoviesResponse?.results?[indexPath.row].id else { return}
        router.showMovieDetail(withId: selectedMovieId)
        
    }
    
    func viewDidLoad() {
        interactor.fetchSelectedMovieDetailsAndSimilarMovies(id: movieId)
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutputProtocol {
    func errorResponse(error: Error) {
        view.showError(descriptiom: error.localizedDescription)
    }
    
    func selectedMovieDetailAndSimilarMoviesResponse(movieDetailResponse: MovieDetailResponse, similarMoviesResponse: SimilarMoviesResponse) {
        guard let similarMoviesResult = similarMoviesResponse.results else { return }
        self.similarMoviesResponse = similarMoviesResponse
        self.movieDetailResponse = movieDetailResponse
        view.selectedMovieDetailAndSimilarMovies(movieDetail: movieDetailResponse, similarMovies: similarMoviesResult)
    }
}
