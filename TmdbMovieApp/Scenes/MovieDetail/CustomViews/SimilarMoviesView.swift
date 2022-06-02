//
//  SimilarMoviesView.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

final class SimilarMoviesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var arrayOfSimilarMovies: [SimilarMoviesResult]?
    var selectedIndex: ((IndexPath) -> ())?
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0, alpha: 0.4)
        label.text = "Similar Movies"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80,
                                 height: 150)
        let collectionview = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ), collectionViewLayout: layout)
        collectionview.isPagingEnabled = false
        collectionview.backgroundColor = .clear
        collectionview.register(SimilarMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "similarCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalToSuperview()
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.labelTitle.snp.bottom)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfSimilarMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarMoviesCollectionViewCell
        guard let movie = arrayOfSimilarMovies?[indexPath.row] else { return UICollectionViewCell()}
        cell.refreshWith(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex?(indexPath)
    }
    
    func refreshWith(similarMovies: [SimilarMoviesResult]) {
        arrayOfSimilarMovies = similarMovies
        collectionView.reloadData()
    }
}
