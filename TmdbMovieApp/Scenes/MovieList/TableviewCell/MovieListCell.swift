//
//  MovieListCell.swift
//  TmdbMovieApp
//
//  Created by bora on 9.09.2021.
//

import UIKit

final class MovieListCell: UITableViewCell  {
    
    private let imageViewCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(white: 0, alpha: 0.4)
        label.numberOfLines = 0
        return label
    }()
    
    private let labelDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(white: 0, alpha: 0.6)
        label.textAlignment = .right
        return label
    }()
    
    private let imageViewArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "arrow")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        if self.traitCollection.userInterfaceStyle == .dark {
            labelDescription.textColor = .white
            labelDate.textColor = .white
        }
        else {
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(imageViewCover)
        imageViewCover.snp.makeConstraints{ (maker) in
            maker.height.width.equalTo(100)
            maker.leading.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().inset(10)
            maker.top.equalToSuperview().offset(10)
        }

        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.imageViewCover.snp.trailing).offset(10)
            maker.top.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().inset(22)
            maker.height.equalTo(20)
        }

        addSubview(labelDescription)
        labelDescription.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.imageViewCover.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().inset(22)
            maker.top.equalTo(self.labelTitle.snp.bottom).offset(5)
            maker.bottom.equalToSuperview().inset(25)
        }

        addSubview(labelDate)
        labelDate.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.imageViewCover.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().inset(22)
            maker.bottom.equalToSuperview().inset(5)
            maker.top.equalTo(self.labelDescription.snp.bottom).offset(5)
            maker.height.equalTo(10)
        }

        addSubview(imageViewArrow)
        imageViewArrow.snp.makeConstraints { (maker) in
            maker.height.equalTo(15)
            maker.width.equalTo(8)
            maker.trailing.equalToSuperview().inset(5)
            maker.centerY.equalToSuperview()
        }
    }
    
    func refreshWith(movie: UpComingResult) {
        labelTitle.text = movie.title
        labelDescription.text = movie.overview
        labelDate.text = movie.releaseDate?.formatDateString()
        imageViewCover.kf.setImage(with: URL(string: "\(Constants.imageBaseUrl)\(movie.posterPath ?? "")"))
    }
    
}
