//
//  MovieListProtocols.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

//MARK: Router
protocol MovieListRouterProtocol: class {
    func showMovieDetail(withId: Int)
}

//MARK: Presenter

protocol MovieListPresenterProtocol: class {
    var interactor: MovieListInteractorInputProtocol! { get set }
    func searchedMovie(movieName: String)
    func viewDidLoad()
    func selectedUpcomingMovieIndex(index: IndexPath)
    func selectedSearchedMovieIndex(index: IndexPath)
}

//MARK: Interactor

// Interactor -> Presenter
protocol MovieListInteractorOutputProtocol: class {
    func nowPlayingAndUpcomingMoviesResponse(nowPlayingMovies: NowPlayingResponse,
                                             upComingMovies: UpComingResponse)
    func searchedMovieResponse(response: SearchMovieResponse)
    func errorResponse(error: Error)
}

// Presenter -> Interactor

protocol MovieListInteractorInputProtocol: class {
    var presenter: MovieListInteractorOutputProtocol! { get set }
    func fetchNowPlayingAndUpcomingMovies()
    func fetchSearchedMovie(movieName: String)
}

//MARK: View

protocol MovieListViewProtocol: class {
    var presenter: MovieListPresenterProtocol! { get set }
    func nowPlayingAndUpcomingMovies(nowPlayingMovies: [NowPlayingResult], upComingMovies: [UpComingResult])
    func searchedMovieResponse(response: [SearchMovieResult])
    func showError(descriptiom: String)
}
