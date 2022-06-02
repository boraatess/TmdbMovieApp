//
//  MovieListInteractor.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import Foundation
import PromiseKit

class MovieListInteractor {
    var presenter: MovieListInteractorOutputProtocol!
    var searchTimer: Timer?

    private var listApi: ListApi
    
    init(listApi: ListApi) {
        self.listApi = listApi
    }
    
    convenience required init () {
        self.init(listApi: ListApi())
    }
}

extension MovieListInteractor: MovieListInteractorInputProtocol {
    func fetchNowPlayingAndUpcomingMovies() {
        firstly {
            when(fulfilled: listApi.fetchNowPlayingMovies(), listApi.fetchUpComingMovies())
        }.done { [unowned self] upComingResponse, nowPlayingResponse in
            self.presenter.nowPlayingAndUpcomingMoviesResponse(nowPlayingMovies: upComingResponse,
                                                               upComingMovies: nowPlayingResponse)
        }.catch { [unowned self] error in
            presenter.errorResponse(error: error)
        }
    }
    
    func fetchSearchedMovie(movieName: String) {
        let params = SearchMovieRequest(query: movieName)
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.searchTimer?.invalidate()
            self.searchTimer = nil
            self.listApi.fetchSearchedMovie(params: params).done { [unowned self] searchResponse in
                self.presenter.searchedMovieResponse(response: searchResponse)
            }.catch { [unowned self] error in
                presenter.errorResponse(error: error)
            }
        })
    }
}
