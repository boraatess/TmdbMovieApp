//
//  MovieListRouter.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

class MovieListRouter {
    
    internal var controller: MovieListViewController!
    internal var presenter: MovieListPresenter!
    internal var interactor: MovieListInteractor!
    
    init() {
        interactor = MovieListInteractor()
        presenter = MovieListPresenter()
        controller = MovieListViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = self
        presenter.view = controller
        controller.presenter = presenter
    }
    
}

extension MovieListRouter: MovieListRouterProtocol {
    func showMovieDetail(withId: Int) {
        guard let vc = MovieDetailRouter(movieId: withId).controller else { return }
        controller.show(vc, sender: nil)
    }
}
