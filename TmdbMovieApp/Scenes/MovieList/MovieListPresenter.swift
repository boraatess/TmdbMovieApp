//
//  MovieListPresenter.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import Foundation

class MovieListPresenter: NSObject {
    
    var view: MovieListViewProtocol!
    var interactor: MovieListInteractorInputProtocol!
    var router: MovieListRouterProtocol!
  
    private var upComingMovieResponse: UpComingResponse?
    private var searchedMoviewResponse: SearchMovieResponse?
}

extension MovieListPresenter: MovieListPresenterProtocol {
    func selectedUpcomingMovieIndex(index: IndexPath) {
        guard let movieId = upComingMovieResponse?.results?[index.row-1].id else { return }
        router.showMovieDetail(withId: movieId)
    }
    
    func selectedSearchedMovieIndex(index: IndexPath) {
        guard let movieId = searchedMoviewResponse?.results?[index.row].id else { return }
        router.showMovieDetail(withId: movieId)
    }
    
    func showMovieDetail(withId: Int) {
        router.showMovieDetail(withId: withId)
    }
    
    func viewDidLoad() {
        interactor.fetchNowPlayingAndUpcomingMovies()
    }
    
    func searchedMovie(movieName: String) {
        movieName.count > 2 ? interactor.fetchSearchedMovie(movieName: movieName) : view.searchedMovieResponse(response: [])
    }
}

extension MovieListPresenter: MovieListInteractorOutputProtocol {
    func errorResponse(error: Error) {
        view.showError(descriptiom: error.localizedDescription)
    }
    
    func nowPlayingAndUpcomingMoviesResponse(nowPlayingMovies: NowPlayingResponse, upComingMovies: UpComingResponse) {
        guard let nowPlayingResults = nowPlayingMovies.results else { return }
        guard let upComingResults = upComingMovies.results else { return }
        self.upComingMovieResponse = upComingMovies
        view.nowPlayingAndUpcomingMovies(nowPlayingMovies: nowPlayingResults, upComingMovies: upComingResults)
    }
    
    func searchedMovieResponse(response: SearchMovieResponse) {
        guard let results = response.results else { return }
        self.searchedMoviewResponse = response
        view.searchedMovieResponse(response: results)
    }
}
