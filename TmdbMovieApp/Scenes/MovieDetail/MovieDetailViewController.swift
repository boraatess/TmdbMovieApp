//
//  MovieDetailViewController.swift
//  TmdbMovieApp
//
//  Created by bora on 8.09.2021.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var presenter: MovieDetailPresenterProtocol!
    let screen = UIScreen.main.bounds
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageViewCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = UIColor(white: 0, alpha: 0.4)
        label.textAlignment = .left
        return label
    }()
    
    private let viewMoviewRateDate: MovieRateDateView = {
        let view = MovieRateDateView()
        return view
    }()
    
    private let viewSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let viewSimilarView: SimilarMoviesView = {
        let view = SimilarMoviesView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout()
        presenter.viewDidLoad()
        listenDidSelectOfSimilarMoviesCollectionView()
        listenDidImdbImageViewPressed()
        if self.traitCollection.userInterfaceStyle == .dark {
            labelTitle.textColor = .black
        }
        else {
            
        }
    }
    
        
}

//MARK: Layout
extension MovieDetailViewController {
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        viewSimilarView.isHidden = true
        viewSeperator.isHidden = true
        scrollView.contentSize = CGSize(width: screen.width, height: screen.height*1.25)
        scrollView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        scrollView.addSubview(viewContent)
        viewContent.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(screen.width)
            maker.centerX.equalToSuperview()
        }
        viewContent.addSubview(imageViewCover)
        imageViewCover.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.width)
        }
        viewContent.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalTo(self.imageViewCover.snp.bottom).offset(15)
        }
        viewContent.addSubview(labelDescription)
        labelDescription.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalTo(self.labelTitle.snp.bottom).offset(15)
        }
        viewContent.addSubview(viewMoviewRateDate)
        viewMoviewRateDate.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.labelDescription.snp.bottom).offset(15)
        }
        viewContent.addSubview(viewSeperator)
        viewSeperator.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.height.equalTo(1)
            maker.top.equalTo(self.viewMoviewRateDate.snp.bottom).offset(15)
        }
        viewContent.addSubview(viewSimilarView)
        viewSimilarView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.viewSeperator.snp.bottom).offset(15)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(270)
        }
    }
    
    private func loadingInducator(isVisible: Bool) {
        isVisible ? LoadingView.shared.show() : LoadingView.shared.hide()
    }
}

//MARK: Actions
extension MovieDetailViewController {
    private func listenDidSelectOfSimilarMoviesCollectionView() {
        viewSimilarView.selectedIndex = { [unowned self] selectedIndex in
            self.presenter.selectedSimilarMovieIndex(indexPath: selectedIndex)
            self.loadingInducator(isVisible: true)
        }
    }
    private func listenDidImdbImageViewPressed() {
        viewMoviewRateDate.imdbPressed = {
            self.presenter.showMovieInImdb()
        }
    }
}

//MARK: Protocols
extension MovieDetailViewController: MovieDetailViewProtocol {
    func showError(descriptiom: String) {
        loadingInducator(isVisible: false)
        AlertService().showNativeAlert(title: "Error", description: description, completion: nil)
    }
    
    func selectedMovieDetailAndSimilarMovies(movieDetail: MovieDetailResponse, similarMovies: [SimilarMoviesResult]) {
        imageViewCover.kf.setImage(with: URL(string: "\(Constants.imageBaseUrl)\(movieDetail.posterPath ?? "")"))
        labelTitle.text = movieDetail.title
        // navigationController?.title = movieDetail.title
        title = movieDetail.title
        labelDescription.text = movieDetail.overview
        viewMoviewRateDate.refreshWith(movieRate: String(movieDetail.voteAverage ?? 0),
                                       releaseDate: movieDetail.releaseDate?.formatDateString() ?? "")
        viewSimilarView.refreshWith(similarMovies: similarMovies)
        loadingInducator(isVisible: false)
    }
}

