//
//  MovieRateDateView.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

final class MovieRateDateView: UIView {
    
    var imdbPressed: (() -> ())?
    
    private let imageViewStar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "star")
        return imageView
    }()
    
    private let labelRate: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0, alpha: 0.4)
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .left
        return label
    }()
    
    private let labelDate: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0, alpha: 0.4)
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageViewLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(imdbImageViewPressed)))
        imageView.image = #imageLiteral(resourceName: "imdb")
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(imageViewLogo)
        imageViewLogo.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.width.equalTo(60)
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(labelDate)
        labelDate.snp.makeConstraints { (maker) in
            maker.bottom.top.equalToSuperview()
            maker.trailing.equalTo(self.imageViewLogo.snp.leading).offset(-5)
            maker.width.equalTo(60)
        }
        
        addSubview(labelRate)
        labelRate.snp.makeConstraints { (maker) in
            maker.bottom.top.equalToSuperview()
            maker.trailing.equalTo(self.labelDate.snp.leading).offset(-5)
            maker.width.equalTo(20)
        }

        addSubview(imageViewStar)
        imageViewStar.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.bottom.top.equalToSuperview()
            maker.trailing.equalTo(self.labelRate.snp.leading).offset(-5)
        }
    }
    
    func refreshWith(movieRate: String, releaseDate: String) {
        labelRate.text = movieRate
        labelDate.text = releaseDate
    }
    
    @objc private func imdbImageViewPressed() {
        imdbPressed?()
    }
}

