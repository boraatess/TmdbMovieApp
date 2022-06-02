//
//  MovieDetailProtocols.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

//MARK: Router
protocol MovieDetailRouterProtocol: class {
    func showMovieDetail(withId: Int)
    func showMovieInImdb(imdbId: String)
}

//MARK: Presenter

protocol MovieDetailPresenterProtocol: class {
    var interactor: MovieDetailInteractorInputProtocol! { get set }
    func viewDidLoad()
    func selectedSimilarMovieIndex(indexPath: IndexPath)
    func showMovieInImdb()
}

//MARK: Interactor

// Interactor -> Presenter
protocol MovieDetailInteractorOutputProtocol: class {
    func selectedMovieDetailAndSimilarMoviesResponse(movieDetailResponse: MovieDetailResponse,
                                                     similarMoviesResponse: SimilarMoviesResponse)
    func errorResponse(error: Error)
}

// Presenter -> Interactor

protocol MovieDetailInteractorInputProtocol: class {
    var presenter: MovieDetailInteractorOutputProtocol! { get set }
    func fetchSelectedMovieDetailsAndSimilarMovies(id: Int)
}

//MARK: View

protocol MovieDetailViewProtocol: class {
    var presenter: MovieDetailPresenterProtocol! { get set }
    func selectedMovieDetailAndSimilarMovies(movieDetail: MovieDetailResponse,
                                                     similarMovies: [SimilarMoviesResult])
    func showError(descriptiom: String)
}
