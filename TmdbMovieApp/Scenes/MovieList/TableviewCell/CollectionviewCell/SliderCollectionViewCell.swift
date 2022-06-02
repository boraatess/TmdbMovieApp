//
//  SliderCollectionViewCell.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit
import Kingfisher

final class SliderCollectionViewCell: UICollectionViewCell {
    
    private let imageViewCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
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
            maker.edges.equalToSuperview()
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().inset(100)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().inset(10)
            maker.top.greaterThanOrEqualTo(self.imageViewCover.snp.centerY)
        }
        addSubview(labelDescription)
        labelDescription.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().inset(50)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().inset(10)
            maker.top.greaterThanOrEqualTo(self.labelTitle.snp.bottom)
        }
    }
    
    func refreshWith(movie: NowPlayingResult) {
        imageViewCover.kf.setImage(with: URL(string: "\(Constants.imageBaseUrl)\(movie.posterPath ?? "")"))
        labelTitle.text = movie.originalTitle
        labelDescription.text = movie.overview
    }
    
}
