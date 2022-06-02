//
//  SplashViewController.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit
import PromiseKit

class SplashViewController: UIViewController {
    
    var presenter: MovieListInteractorOutputProtocol!
    private var listApi = ListApi()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchData()
        
    }
    
}

extension SplashViewController {
    
    private func fetchData() {
        firstly {
            when(fulfilled: listApi.fetchNowPlayingMovies(), listApi.fetchUpComingMovies())
        }.done { [unowned self] upComingResponse, nowPlayingResponse in
            let listRouter = MovieListRouter()
            let vc = UINavigationController(rootViewController: listRouter.controller)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }.catch { [unowned self] error in
            let alert = UIAlertController(title: "Network Connection Error", message: "Please check your wifi/cellular connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Go Settings", style: .default) { (action) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                }
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
