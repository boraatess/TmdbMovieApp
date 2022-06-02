//
//  SliderTableviewCell.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

class SliderTableviewCell: UITableViewCell {
    
    private var movies: [NowPlayingResult]?
    var timer = Timer()
    var counter = 0
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.width)
        let collectionview = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ), collectionViewLayout: layout)
        collectionview.isPagingEnabled = true
        collectionview.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: "sliderCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .black
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeImage() {
        DispatchQueue.main.async {
            if self.counter < self.movies?.count ?? 0 {
                let index = IndexPath.init(item: self.counter, section: 0)
                self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = self.counter
                self.counter += 1
            }
            else {
                self.counter = 0
                let index = IndexPath.init(item: self.counter, section: 0)
                self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                self.pageControl.currentPage = self.counter
                self.counter = 1
            }
        }
    }
    
    private func layout() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.width*0.6)
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (maker) in
            maker.leading.greaterThanOrEqualTo(self.snp.leading).offset(10)
            maker.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-10)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(10)
            maker.height.equalTo(20)
        }
    }
    
    func refreshWith(movies: [NowPlayingResult]) {
        self.movies = movies
        self.pageControl.numberOfPages = movies.count
        self.collectionView.reloadData()
    }
    
    
}

//MARK: UICollectionView Delegate

extension SliderTableviewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! SliderCollectionViewCell
        guard let movie = movies?[indexPath.row] else { return UICollectionViewCell() }
        cell.refreshWith(movie: movie)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let row = collectionView.indexPath(for: cell)?.item {
                pageControl.currentPage = row
            }
        }
    }
}
