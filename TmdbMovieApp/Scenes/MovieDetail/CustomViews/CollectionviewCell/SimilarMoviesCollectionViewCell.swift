//
//  SimilarMoviesCollectionViewCell.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

final class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    
    private let imageViewCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0, alpha: 0.4)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(imageViewCover)
        imageViewCover.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.height.equalTo(100)
        }
        
        addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.imageViewCover.snp.bottom).offset(3)
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    func refreshWith(movie: SimilarMoviesResult) {
        label.text = "\(movie.title ?? "") \n\(movie.releaseDate?.formatFilterYearDate() ?? "")"
        imageViewCover.kf.setImage(with: URL(string: "\(Constants.imageBaseUrl)\(movie.posterPath ?? "")"))
    }
}
