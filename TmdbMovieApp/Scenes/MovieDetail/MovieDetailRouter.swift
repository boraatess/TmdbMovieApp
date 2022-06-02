//
//  MovieDetailRouter.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

class MovieDetailRouter {
    
    internal var controller: MovieDetailViewController!
    internal var presenter: MovieDetailPresenter!
    internal var interactor: MovieDetailInteractor!
    
    init(movieId: Int) {
        interactor = MovieDetailInteractor()
        presenter = MovieDetailPresenter(movieId: movieId)
        controller = MovieDetailViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = self
        presenter.view = controller
        controller.presenter = presenter
    }
}

extension MovieDetailRouter: MovieDetailRouterProtocol {
    func showMovieInImdb(imdbId: String) {
        if let url = URL(string: "https://www.imdb.com/title/\(imdbId)/") {
            UIApplication.shared.open(url)
        }
    }
    
    func showMovieDetail(withId: Int) {
        guard let vc = MovieDetailRouter(movieId: withId).controller else { return }
        controller.show(vc, sender: nil)
    }
}
