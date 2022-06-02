//
//  MovieListViewController.swift
//  TmdbMovieApp
//
//  Created by bora on 8.09.2021.
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController {
   
    var presenter: MovieListPresenterProtocol!

    private var arrayOfUpcomingMovies: [UpComingResult]?
    private var arrayOfNowPlayingMovies: [NowPlayingResult]?
    private var arrayOfSearchedMovies: [SearchMovieResult]?
    let screen = UIScreen.main.bounds
    let refreshControl = UIRefreshControl()

    private lazy var tableViewOfList: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SliderTableviewCell.self, forCellReuseIdentifier: "sliderCell")
        tableView.register(MovieListCell.self, forCellReuseIdentifier: "movieListCell")
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.setValue("Cancel", forKey: "cancelButtonText")
        searchBar.placeholder = "Search Movies"
        return searchBar
    }()
    
    private lazy var tableViewOfSearchBar: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        tableView.alpha = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout()
        presenter.viewDidLoad()
        loadingInducator(isVisible: true)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = searchBar
    }
    
    @objc func refresh(_ sender: AnyObject) {
        presenter.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
}

extension MovieListViewController {
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(tableViewOfList)
        tableViewOfList.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        tableViewOfList.addSubview(refreshControl)
        view.addSubview(tableViewOfSearchBar)
        tableViewOfSearchBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        tableViewOfList.tableFooterView = UIView()
    }
    
    private func tableViewOfSearchBar(isVisiable: Bool) {
        isVisiable ? (tableViewOfSearchBar.isHidden = !isVisiable) : nil
        UIView.animate(withDuration: 0.3) {
            self.tableViewOfSearchBar.alpha = isVisiable ? 1 : 0
        } completion: { [unowned self]_ in
            isVisiable ? nil : (self.tableViewOfSearchBar.isHidden = !isVisiable)
        }
    }
    
    private func loadingInducator(isVisible: Bool) {
        isVisible ? LoadingView.shared.show() : LoadingView.shared.hide()
        
    }
    
}
    
extension MovieListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(searchBar: searchBar ,isEditing: false)
        self.searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar(searchBar: searchBar, isEditing: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         presenter.searchedMovie(movieName: searchText)
    }
    
    private func searchBar(searchBar: UISearchBar, isEditing: Bool) {
        searchBar.showsCancelButton = isEditing
        _ = isEditing ? searchBar.becomeFirstResponder() :  searchBar.endEditing(true)
        tableViewOfSearchBar(isVisiable: isEditing)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let upComingMovieCount = ((arrayOfUpcomingMovies?.count ?? 0) + 1) > 1 ? (arrayOfUpcomingMovies?.count ?? 0) + 1 : 0
        return tableView == tableViewOfList ? upComingMovieCount : (arrayOfSearchedMovies?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewOfList == tableView && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as! SliderTableviewCell
            guard let movies = arrayOfNowPlayingMovies else { return UITableViewCell()}
            cell.refreshWith(movies: movies)
            return cell
        } else if tableViewOfList == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath) as! MovieListCell
            guard let movie = arrayOfUpcomingMovies?[indexPath.row-1] else { return UITableViewCell()}
            cell.refreshWith(movie: movie)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            guard let movie = arrayOfSearchedMovies?[indexPath.row] else { return UITableViewCell()}
            cell.textLabel?.text = movie.originalTitle
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == tableViewOfList && indexPath.row > 0 {
            presenter.selectedUpcomingMovieIndex(index: indexPath)
            LoadingView.shared.show()
        } else if tableView == tableViewOfSearchBar {
            presenter.selectedSearchedMovieIndex(index: indexPath)
            LoadingView.shared.show()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableViewOfList == tableView && indexPath.row == 0 {
            return screen.width
        }
        else if tableViewOfList == tableView && indexPath.row > 0 {
            return 150
        }
        else {
            return 50
        }
    }
        
}

//MARK: Protocols

extension MovieListViewController: MovieListViewProtocol {
    func showError(descriptiom: String) {
        loadingInducator(isVisible: false)
        AlertService().showNativeAlert(title: "Error", description: description, completion: nil)
    }
    
    func nowPlayingAndUpcomingMovies(nowPlayingMovies: [NowPlayingResult], upComingMovies: [UpComingResult]) {
        self.arrayOfUpcomingMovies = upComingMovies
        self.arrayOfNowPlayingMovies = nowPlayingMovies
        self.tableViewOfList.reloadData()
        loadingInducator(isVisible: false)
    }
    
    func searchedMovieResponse(response: [SearchMovieResult]) {
        self.arrayOfSearchedMovies = response
        self.tableViewOfSearchBar.reloadData()
    }
}
